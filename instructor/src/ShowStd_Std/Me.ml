(* Adapted from https://github.com/c-cube/tiny_httpd/blob/6203e7a4a7ff8ff0c2ea80b78f029057909f30da/src/bin/http_of_dir.ml *)

module Arg = Tr1Stdlib_V414CRuntime.Arg
module Printf = Tr1Stdlib_V414CRuntime.Printf
module Scanf = Tr1Stdlib_V414CRuntime.Scanf
module S = Tr1TinyHttpd_Std.TinyHttpd
module D = Tr1TinyHttpd_Std.TinyHttpd.Dir
module Log = Tr1TinyHttpd_Std.TinyHttpd.Log
module Format = Tr1Stdlib_V414CRuntime.Format
module IO = Tr1TinyHttpd_Std.TinyHttpd.IO
module String = Tr1Stdlib_V414Base.String

let content_type_middleware
    (existing_chain :
      IO.Input.t S.Request.t -> resp:(S.Response.t -> unit) -> unit) =
 fun (req : IO.Input.t S.Request.t) ~(resp : S.Response.t -> unit) : unit ->
  match S.Request.path req with
  | path when String.ends_with ~suffix:".wasm" path ->
      existing_chain req ~resp:(fun r ->
          let r' = S.Response.set_header "Content-Type" "application/wasm" r in
          resp r')
  | _ -> existing_chain req ~resp

let serve ~config ~timeout (dir : string) addr port j : _ result =
  let server = S.create ~max_connections:j ~addr ~port ~timeout () in
  let after_init () =
    Printf.printf "serve directory %s on http://%(%s%):%d\n%!" dir
      (if S.is_ipv6 server then "[%s]" else "%s")
      addr (S.port server)
  in

  D.add_dir_path ~config ~dir ~prefix:"" server;
  S.add_middleware ~stage:(`Stage 10) server content_type_middleware;
  S.run ~after_init server

let parse_size s : int =
  try Scanf.sscanf s "%dM" (fun n -> n * 1_024 * 1_024)
  with _ -> (
    try Scanf.sscanf s "%dk" (fun n -> n * 1_024)
    with _ -> (
      try int_of_string s
      with _ -> raise (Arg.Bad "invalid size (expected <int>[kM]?)")))

let main () =
  let config = D.config ~dir_behavior:Index_or_lists () in
  let dir_ = ref "." in
  let addr = ref "127.0.0.1" in
  let port = ref 8080 in
  let timeout = ref 30. in
  let j = ref 32 in
  Arg.parse
    (Arg.align
       [
         ("--addr", Set_string addr, " address to listen on");
         ("-a", Set_string addr, " alias to --listen");
         ("--port", Set_int port, " port to listen on");
         ("-p", Set_int port, " alias to --port");
         ("--dir", Set_string dir_, " directory to serve (default: \".\")");
         ("--debug", Unit (Log.setup ~debug:true), " debug mode");
         ("--timeout", Arg.Set_float timeout, " TCP timeout on sockets");
         ( "--upload",
           Unit (fun () -> config.upload <- true),
           " enable file uploading" );
         ( "--no-upload",
           Unit (fun () -> config.upload <- false),
           " disable file uploading" );
         ( "--download",
           Unit (fun () -> config.download <- true),
           " enable file downloading" );
         ( "--no-download",
           Unit (fun () -> config.download <- false),
           " disable file downloading" );
         ( "--max-upload",
           String (fun i -> config.max_upload_size <- parse_size i),
           " maximum size of files that can be uploaded" );
         ( "--auto-index",
           Bool
             (fun b ->
               config.dir_behavior <- (if b then Index_or_lists else Lists)),
           " <bool> automatically redirect to index.html if present" );
         ( "--delete",
           Unit (fun () -> config.delete <- true),
           " enable `delete` on files" );
         ( "--no-delete",
           Unit (fun () -> config.delete <- false),
           " disable `delete` on files" );
         ("-j", Set_int j, " maximum number of simultaneous connections");
       ])
    (fun s -> dir_ := s)
    (__MODULE_ID__ ^ " [options] [dir]");
  match serve ~config ~timeout:!timeout !dir_ !addr !port !j with
  | Ok () -> ()
  | Error e -> raise e

let __init (_ : DkCoder_Std.Context.t) = main ()

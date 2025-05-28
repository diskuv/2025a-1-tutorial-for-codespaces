module Bos = Tr1Bos_Std.Bos
module Bytes = Tr1Stdlib_V414Base.Bytes
module Cmdliner = Tr1Cmdliner_Std.Cmdliner
module Fpath = Tr1Fpath_Std.Fpath
module Http = DkNet_Std.Http
module List = Tr1Stdlib_V414Base.List
module Logs = Tr1Logs_Std.Logs
module Option = Tr1Stdlib_V414Base.Option
module Result = Tr1Stdlib_V414Base.Result
module StdExit = Tr1Stdlib_V414Extras.StdExit
module Sys = Tr1Stdlib_V414CRuntime.Sys
module Uri = Tr1Uri_Std.Uri
module Unix = Tr1Stdlib_V414CRuntime.Unix

let sha256_file file =
  let ctx = ref (Digestif.SHA256.init ()) in
  let res =
    Bos.OS.File.with_input ~bytes:(Bytes.create 32_768) file
      (fun f () ->
        let rec feedloop = function
          | Some (b, pos, len) ->
              ctx := Digestif.SHA256.feed_bytes !ctx ~off:pos ~len b;
              feedloop (f ())
          | None -> Digestif.SHA256.get !ctx
        in
        feedloop (f ()))
      ()
  in
  Result.map Digestif.SHA256.to_hex res

let send ~host () =
  let ctx = DkCoder_Std.Context.get_exn () in
  let projectdir = DkCoder_Std.Context.project_dir ctx |> Option.get in
  (* Define where [ffsend] should be downloaded from and saved to *)
  let ffsend, sha256, uri =
    match DkCoder_Std.Host.abi with
    | `Linux_x86_64 ->
        ( Fpath.(
            v projectdir / "ScoutTrainingApp" / "bin" / "ffsend"
            / "linux-x64-static"),
          "ebd14a67c46e7d744ce84677f057d9dc07abc884eaa8f70d68a9e59d27357313",
          "https://github.com/timvisee/ffsend/releases/download/v0.2.77/ffsend-v0.2.77-linux-x64-static"
        )
    | `Windows_x86_64 ->
        ( Fpath.(
            v projectdir / "ScoutTrainingApp" / "bin" / "ffsend"
            / "windows-x64-static.exe"),
          "09d923348d083c130e8e26f990ba4c90022a2b26e6a9f0c55ac78420f84089f8",
          "https://github.com/timvisee/ffsend/releases/download/v0.2.76/ffsend-v0.2.76-windows-x64-static.exe"
        )
    | `Darwin_arm64 | `Darwin_x86_64 ->
        ( Fpath.(v projectdir / "ScoutTrainingApp" / "bin" / "ffsend" / "macos"),
          "61d28a3f24dc3beb74e8b6d1de28bca760685b81bff907142c51e58f6bc8ff87",
          "https://github.com/timvisee/ffsend/releases/download/v0.2.76/ffsend-v0.2.76-macos"
        )
    | _ ->
        Logs.err (fun l ->
            l "Unsupported host abi %s" DkCoder_Std.Host.abi_name);
        StdExit.exit 1
  in
  (* Download [ffsend] if needed *)
  if Bos.OS.File.exists ffsend = Ok true && sha256_file ffsend = Ok sha256 then
    Logs.debug (fun l -> l "Re-using ffsend")
  else begin
    Lwt_main.run
      (Http.download_url ~checksum:(`SHA_256 sha256) ~destination:ffsend
         (Uri.of_string uri));
    if not Sys.win32 then Unix.chmod (Fpath.to_string ffsend) 0o755
  end;
  (* Find source files *)
  let sourcefiles =
    let res =
      Bos.OS.Path.fold
        ~traverse:
          (`Sat
             (fun path ->
               (* Use every directory except build directories [bin] and [obj] *)
               match Fpath.basename path with
               | "bin" | "obj" -> Ok false
               | _ -> Ok true))
        (fun v acc -> v :: acc)
        []
        [ Fpath.(v projectdir / "ScoutTrainingApp") ]
    in
    match res with
    | Ok v -> v
    | Error (`Msg msg) ->
        Logs.err (fun l ->
            l "@[<v>finding source files failed ...@ %a@]" Fmt.lines msg);
        StdExit.exit 3
  in
  let sourcefiles' =
    Fpath.(v projectdir / "content" / "TUTORIAL.md")
    :: List.filter
         (fun i ->
           Logs.debug (fun l -> l "+ %a" Fpath.pp i);
           Bos.OS.File.exists i = Ok true)
         sourcefiles
  in
  (* Bundle and send workspace *)
  let cmd =
    Bos.Cmd.(
      v (p ffsend)
      % "upload" % "--no-interact" % "--force" % "--quiet" % "--host" % host
      % "--incognito" % "--archive"
      %% of_list (List.map Fpath.to_string sourcefiles'))
  in
  match
    (* Scriptability: https://github.com/timvisee/ffsend?tab=readme-ov-file#scriptability *)
    Bos.OS.Cmd.(in_null |> run_io cmd |> to_string ~trim:true)
  with
  | Ok s -> Fmt.pr "Paste this link in the chat window:@;  %s@." s
  | Error (`Msg msg) ->
      Logs.err (fun l -> l "@[<v>upload failed ...@ %a@]" Fmt.lines msg);
      StdExit.exit 2

let __init () =
  Tr1Logs_Term.TerminalCliOptions.init ();
  let open Cmdliner in
  let host_t =
    let doc =
      "The remote host to upload to. A list is available at \
       https://github.com/timvisee/send-instances/."
    in
    Arg.(
      value
      & opt string "https://send.monks.tools"
      & info ~doc ~env:(Cmd.Env.info "FFSEND_HOST") [ "host" ])
  in
  let publish_t =
    Term.(
      const (fun _cliopts host -> send ~host ())
      $ Tr1Logs_Term.TerminalCliOptions.term ~short_opts:() ()
      $ host_t)
  in
  let publish_cmd = Cmd.v (Cmd.info __MODULE_ID__) publish_t in
  StdExit.exit (Cmd.eval publish_cmd)

module Bos = Tr1Bos_Std.Bos
module Cmdliner = Tr1Cmdliner_Std.Cmdliner
module Logs = Tr1Logs_Std.Logs
module StdExit = Tr1Stdlib_V414Extras.StdExit

let publish () =
  let open Bos in
  match
    OS.Cmd.run
      Cmd.(
        v "dotnet" % "publish" % "ScoutTrainingApp.Browser" % "--configuration"
        % "Debug" % "--no-restore")
  with
  | Ok () -> ()
  | Error (`Msg msg) ->
      Logs.err (fun l -> l "dotnet publish failed ...@ %a" Fmt.lines msg)

let publish_continually () =
  while true do
    publish ()
  done

let __init () =
  Tr1Logs_Term.TerminalCliOptions.init ();
  let open Cmdliner in
  let publish_t =
    Term.(
      const (fun _cliopts -> publish_continually ())
      $ Tr1Logs_Term.TerminalCliOptions.term ())
  in
  let publish_cmd = Cmd.v (Cmd.info __MODULE_ID__) publish_t in
  StdExit.exit (Cmd.eval publish_cmd)

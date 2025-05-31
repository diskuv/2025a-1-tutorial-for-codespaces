module Bos = Tr1Bos_Std.Bos
module Cmdliner = Tr1Cmdliner_Std.Cmdliner
module Fpath = Tr1Fpath_Std.Fpath
module Logs = Tr1Logs_Std.Logs
module Option = Tr1Stdlib_V414Base.Option
module Result = Tr1Stdlib_V414Base.Result
module StdExit = Tr1Stdlib_V414Extras.StdExit

(** Cleans the intermediate and output directories.

    Unlike ["dotnet clean"], this command will remove the ["bin/"] and ["obj/"]
    directories entirely, which is essential when moving back and forth from the
    local PC to a Dev Container. *)

let clean () =
  let ctx = DkCoder_Std.Context.get_exn () in
  let project_dir =
    DkCoder_Std.Context.project_dir ctx |> Option.get |> Fpath.v
  in
  match
    DkFs_C99.Path.rm ~recurse:() ~force:()
      Fpath.
        [
          project_dir / "ScoutTrainingApp" / "bin";
          project_dir / "ScoutTrainingApp" / "obj";
          project_dir / "ScoutTrainingApp.Android" / "bin";
          project_dir / "ScoutTrainingApp.Android" / "obj";
          project_dir / "ScoutTrainingApp.Browser" / "bin";
          project_dir / "ScoutTrainingApp.Browser" / "obj";
          project_dir / "ScoutTrainingApp.Desktop" / "bin";
          project_dir / "ScoutTrainingApp.Desktop" / "obj";
          project_dir / "ScoutTrainingApp.iOS" / "bin";
          project_dir / "ScoutTrainingApp.iOS" / "obj";
        ]
  with
  | Ok () -> ()
  | Error (`Msg msg) ->
      Logs.err (fun l -> l "%s failed ...@ %a" __MODULE_ID__ Fmt.lines msg);
      StdExit.exit 1

let __init () =
  Tr1Logs_Term.TerminalCliOptions.init ();
  let open Cmdliner in
  let clean_t =
    Term.(
      const (fun _cliopts -> clean ()) $ Tr1Logs_Term.TerminalCliOptions.term ())
  in
  let clean_cmd = Cmd.v (Cmd.info __MODULE_ID__) clean_t in
  StdExit.exit (Cmd.eval clean_cmd)

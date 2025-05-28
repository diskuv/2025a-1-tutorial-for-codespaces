---
presentation:
  slideNumber: true
---

# Tutorial

## Are you in the right place?

**Verify:**

- [ ] that you are inside GitHub Codespaces. Your web browser should be on a page with `https://xxx-xxx-xxxx.github.dev/` in the address bar. If not, start over from the [README.md document](../README.md).

## Show the empty app

Ctrl-Shift-P, then `Live Preview: Start Server`

**Verify:**

- [ ] a `ScoutTrainingApp.Browser` tab appears on the right hand side

## Start the app build

First, press Ctrl-Shift-B and you should see a `Build.Me` Task running in the bottom right.

Second, click on [ScoutTrainingApp\ViewModels\MainViewModel.cs](../ScoutTrainingApp/ViewModels/MainViewModel.cs) and change the line:

```csharp
private string _greeting = "Welcome to Scout Training!";
```

to the following (replace *YOUR FIRST NAME* with your real first name!):

```csharp
private string _greeting = "Welcome to Scout Training, YOUR FIRST NAME!";
```

**Verify:**

- [ ] within 30 seconds you see the change in the `ScoutTrainingApp.Browser` tab on the right hand side.

## Send changes to the instructor

```ocaml {cmd="dk" args=["--project-dir", "..", "-s", "$input_file", "Run"]}
let __init () = SendStd_Std.Me.__init ()
```

**Verify:**

- [ ] you see and have followed the instruction `Paste this link in the chat window`.
- [ ] your instructor tells you they received your changes.

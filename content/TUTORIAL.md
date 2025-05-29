---
presentation:
  slideNumber: true
---

# Tutorial

## Are you in the right place?

Press Ctrl-Shift-P, then `Markdown: Markdown Preview Enhanced: Open Preview to the Side`.

Press Ctrl-Shift-P, then `Preferences: Color Theme`. It is currently `GitHub Dark`. You might want `GitHub Light` or `GitHub Light (colorblind)` instead.

> ℹ️ You must refresh your web browser to see the color theme changes.

**Verify:**

- [ ] that you are inside GitHub Codespaces. Your web browser should be on a page with `https://xxx-xxx-xxxx.github.dev/` in the address bar. If not, start over from the [README.md document](../README.md).

## Start the app build

Press Ctrl-Shift-B and you should see a `Build.Me` Task running in the bottom right. It will take 5 minutes the first time for it to say repeatedly:

```text
Build succeeded in 3.6s
  ScoutTrainingApp succeeded (0.2s) → ScoutTrainingApp/bin/Debug/net8.0/ScoutTrainingApp.dll
  ScoutTrainingApp succeeded (0.1s) → ScoutTrainingApp/bin/Debug/net8.0/ScoutTrainingApp.dll
  ScoutTrainingApp.Browser succeeded (1.9s) → ScoutTrainingApp.Browser/bin/Debug/net8.0-browser/publish/
```

**Verify:**

- [ ] you can see the `Build succeeded`

## Show the minimal app

Press Ctrl-Shift-P, then `Avalonia: Show Preview`.
You may get a popup at the bottom right saying:

```text
Previewer is not available. Build the project first.
Source: Avalonia for VSCode      [Build] [Close]
```

Press the `[Build]` button if you see that popup.

---

ALTERNATIVE: Run in the Terminal (TODO: button or vscode task?):

```sh
python3 -m http.server --bind 127.0.0.1 -d ScoutTrainingApp.Browser/bin/Debug/net8.0-browser/publish/wwwroot 3100
```

~~Ctrl-Shift-P, then `Live Preview: Start Server`~~

---

**Verify:**

- [ ] ~~a `ScoutTrainingApp.Browser` tab appears on the right hand side. It may have a red circle with a slash across it ... that is expected!~~
- [ ] you get a popup in the lower right saying:

  ```text
  Your application running on port 3100 is available.  [See all forwarded ports]
        [Open in Browser] [Make Public]
  ```

- [ ] you have done **Open in Browser** and can see the "Welcome to Scout Training"

## Make your first change

Click on [ScoutTrainingApp\ViewModels\MainViewModel.cs](../ScoutTrainingApp/ViewModels/MainViewModel.cs) and change the line:

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

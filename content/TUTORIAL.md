# Tutorial

## Are you in the right place?

Press Ctrl-Shift-P, then `Markdown: Markdown Preview Enhanced: Open Preview to the Side`.

Press Ctrl-Shift-P, then `Preferences: Color Theme`. It is currently `Default High Contrast`. You might want `GitHub Dark`, `GitHub Light` or `GitHub Light (colorblind)` instead.

> ℹ️ For GitHub Codespaces users, you must refresh your web browser to see the color theme changes.

**Verify:**

- [ ] that you are inside GitHub Codespaces. Your web browser should be on a page with `https://xxx-xxx-xxxx.github.dev/` in the address bar. If not, start over from the [README.md document](../README.md).

## Start the Browser app build

Press Ctrl-Shift-B and you should see a `Build.Me` Task running in the bottom right. It will take 5 minutes the first time for it to say **repeatedly**:

```text
Build succeeded in 3.6s
  ScoutTrainingApp succeeded (0.2s) → ScoutTrainingApp/bin/Debug/net8.0/ScoutTrainingApp.dll
  ScoutTrainingApp succeeded (0.1s) → ScoutTrainingApp/bin/Debug/net8.0/ScoutTrainingApp.dll
  ScoutTrainingApp.Browser succeeded (1.9s) → ScoutTrainingApp.Browser/bin/Debug/net8.0-browser/publish/
```

**Verify:**

- [ ] you can see the `Build succeeded`

## Run the Desktop app (only local PC users)

> ℹ️ This is only if you are running VS Code **directly** on a desktop computer or a laptop. If you are running in GitHub Codespaces, you are running a remote computer and you should skip this step.

Press Ctrl-Shift-P, then `Tasks: Run Task`. Then select `Run.Me`.

**Verify:**

- [ ] a new window appeared with `Welcome to Scout Training!` in the middle

## Preview the Desktop app (only local PC users)

Press Ctrl-Shift-P, then `Avalonia: Show Preview`.
You may get a popup at the bottom right saying:

```text
Previewer is not available. Build the project first.
Source: Avalonia for VSCode      [Build] [Close]
```

Press the `[Build]` button if you see that popup.

**Verify:**

- [ ] you see the "Welcome to Scout Training"

## Preview the Desktop app (only GitHub Codespaces users)

Click on [ScoutTrainingApp/Views/MainView.axaml](../ScoutTrainingApp/Views/MainView.axaml).

Press Ctrl-Shift-P, then `Avalonia: Show Preview`.
You may get a popup at the bottom right saying:

```text
Previewer is not available. Build the project first.
Source: Avalonia for VSCode      [Build] [Close]
```

Press the `[Build]` button if you see that popup.

Then you will see a `Preview MainView.axaml` tab
appear on the right hand side. But it will show a big 🚫 symbol (a red
circle with a slash across it)!

Press Ctrl-Shift-P, then `Ports: Focus on the Ports View`.
On the line that has `8000` in the first **Ports** column there will be a 🌐 symbol
(a globe) in the second **Forwarded Ports** column.

Click on that globe and a new browser window will appear.

**Verify:**

- [ ] you see the "Welcome to Scout Training"

## Show the Browser app (only local PC users)

Press Ctrl-Shift-P, then `Tasks: Run Task`. Then select `Show.Me`.

Open a new web browser page to <http://localhost:3100>.

---

**Verify:**

- [ ] you can see the "Welcome to Scout Training" in your browser window

## Show the Browser app (only GitHub Codespaces users)

Press Ctrl-Shift-P, then `Tasks: Run Task`. Then select `Show.Me`.

You *should* get a popup in the lower right saying:

```text
Your application running on port 3100 is available.  [See all forwarded ports]
      [Open in Browser] [Make Public]
```

Click **Open in Browser**.

> ℹ️ What if you don't see the popup? Press Ctrl-Shift-P, then `Ports: Focus on the Ports View`. On the line that has `3100` in the first **Ports** column there will be a 🌐 symbol
(a globe) in the second **Forwarded Ports** column. Click on that globe and a new browser window will appear.

---

**Verify:**

- [ ] you have clicked on the **Open in Browser** button (or the globe) and can see the "Welcome to Scout Training"

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

- [ ] (local PC) within two minutes you see the change in the `ScoutTrainingApp.Browser` tab on the right hand side.
- [ ] (GitHub Codespaces) within a minute you see the change in your *second* browser window

## Send changes to the instructor

```ocaml {cmd="dk" args=["--project-dir", "..", "-s", "$input_file", "Run"]}
let __init () = SendStd_Std.Me.__init ()
```

**Verify:**

- [ ] you see and have followed the instruction `Paste this link in the chat window`.
- [ ] your instructor tells you they received your changes.

# Tutorial

## Are you in the right place?

You should be viewing this in a Chrome or Edge browser. Do not use Safari on macOS!

Open the Command Palette (Cmd/Ctrl + Shift + P), then `Markdown: Markdown Preview Enhanced: Open Preview to the Side`.

Open the Command Palette (Cmd/Ctrl + Shift + P), then `Preferences: Color Theme`. It is currently `Default High Contrast`. You might want `GitHub Dark`, `GitHub Light` or `GitHub Light (colorblind)` instead.

> ℹ️ You must refresh your web browser to see the color theme changes.

**Verify:**

- [ ] that you are inside GitHub Codespaces. Your web browser should be on a page with `https://xxx-xxx-xxxx.github.dev/` in the address bar. If not, start over from the [README.md document](../README.md).

## Start the Browser app build

Open the Command Palette (Cmd/Ctrl + Shift + P), then `Tasks: Run Build Task` and you should see a `Build.Me` Task running in the bottom right. It will take 5 minutes the first time for it to say **repeatedly**:

```text
Build succeeded in 3.6s
  ScoutTrainingApp succeeded (0.2s) → ScoutTrainingApp/bin/Debug/net8.0/ScoutTrainingApp.dll
  ScoutTrainingApp succeeded (0.1s) → ScoutTrainingApp/bin/Debug/net8.0/ScoutTrainingApp.dll
  ScoutTrainingApp.Browser succeeded (1.9s) → ScoutTrainingApp.Browser/bin/Debug/net8.0-browser/publish/
```

**Verify:**

- [ ] you can see the `Build succeeded`

## Preview the Desktop app

Click on [ScoutTrainingApp/Views/MainView.axaml](../ScoutTrainingApp/Views/MainView.axaml).

> ℹ️ Is `MainView.axaml` in black and white in GitHub Codespaces? To get color, **refresh your web browser**! Then go back to the first step of the tutorial.

Open the Command Palette (Cmd/Ctrl + Shift + P), then `Avalonia: Show Preview`.

> You may get a popup at the bottom right saying:
>
> ```text
> Previewer is not available. Build the project first.
> Source: Avalonia for VSCode      [Build] [Close]
> ```
>
> Press the `[Build]` button if you see that popup.

Then you will see a `Preview MainView.axaml` tab
appear on the right hand side. But it will show a big 🚫 symbol (a red
circle with a slash across it)!

Open the Command Palette (Cmd/Ctrl + Shift + P), then `Ports: Focus on the Ports View`.
On the line that has `8000` in the first **Ports** column there will be a 🌐 symbol
(a globe) in the second **Forwarded Ports** column.

Click on that globe and a new browser window will appear. From now on we will call that new browser window the **Desktop Preview Window**.

**See nothing in the Desktop Preview Window?**

1. (*skip this; may be useless*) Click on [ScoutTrainingApp/Views/MainView.axaml](../ScoutTrainingApp/Views/MainView.axaml) again,
and add a blank line to the end of MainView.axml.
2. Close the `Preview MainView.axaml` tab. After it is closed, Open the Command Palette (Cmd/Ctrl + Shift + P), then `Avalonia: Show Preview`.
3. In your Desktop Preview Window, reload the page (*skip: while pressing Shift*).

**Verify:**

- [ ] you see the "Welcome to Scout Training"

## Show the Browser app

Open the Command Palette (Cmd/Ctrl + Shift + P), then `Tasks: Run Test Task`. Then select `Show.Me`.

You *should* get a popup in the lower right saying:

```text
Your application running on port 3100 is available.  [See all forwarded ports]
      [Open in Browser] [Make Public]
```

Click **Open in Browser**.

> ℹ️ What if you don't see the popup? Open the Command Palette (Cmd/Ctrl + Shift + P), then `Ports: Focus on the Ports View`. On the line that has `3100` in the first **Ports** column there will be a 🌐 symbol
(a globe) in the second **Forwarded Ports** column. Click on that globe and a new browser window will appear.

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
- [ ] (GitHub Codespaces) within a minute you see the change in your Desktop Preview Window

## Start the lessons

Open the Command Palette (Cmd/Ctrl + Shift + P), then `Tasks: Run Test Task`.

There are several lessons you can start. They all are `Turn to [the lesson number]`.

Your instructor will tell you which lesson number for today. If you are self-directed, do each lesson number in lowest-to-highest order.

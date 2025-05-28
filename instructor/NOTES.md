# Notes for the trainer

If you are learning (you are a student, etc.) this is **not meant for you**!

## Markdown Documentation

With:

* The Markdown Preview Enhanced plugin
* The vscode setting `"markdown-preview-enhanced.automaticallyShowPreviewOfMarkdownBeingEdited": true` to make any `.md` Markdown document have a preview opened automatically.
* The devcontainer setting `"openFiles": ["content/TUTORIAL.md"]` to open the tutorial when GitHub Codespaces starts

we can use:

* The `<-- slide -->` element and frontmatter to create presentation slides:
<https://shd101wyy.github.io/markdown-preview-enhanced/#/presentation?id=presentation-front-matter>
* The code chunks to create executable blocks: <https://shd101wyy.github.io/markdown-preview-enhanced/#/code-chunk>

## Developing with Dev Containers

Install the `Dev Containers (ms-vscode-remote.remote-containers)` extension from the [VS Code Marketplace](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers).

## Installing from scratch locally on Windows

### 1 - dotnet

Download and install **.NET 8.0 LTS** from <https://dotnet.microsoft.com/en-us/download>.

As of 2025-May the [support policy](https://dotnet.microsoft.com/en-us/platform/support/policy/dotnet-core) is:

| Version | Original release date | Latest patch version | Patch release date | Release type | Support phase | End of support    |
| ------- | --------------------- | -------------------- | ------------------ | ------------ | ------------- | ----------------- |
| .NET 9  | November 12, 2024     | 9.0.5                | May 13, 2025       | STS          | Active        | May 12, 2026      |
| .NET 8  | November 14, 2023     | 8.0.16               | May 13, 2025       | LTS          | Active        | November 10, 2026 |

Verify with:

```sh
$ dotnet --version
8.0.313
```

After the project has been setup you can switch to dotnet 9. But we want the code to be dotnet 8 since it will be supported longer.

### 2 - Avalonia

This is from <https://docs.avaloniaui.net/docs/get-started/install> ...

We will install **Avalonia Cross Platform Application**.

```sh
# This might complain that there is no project. That is fine.
dotnet new install Avalonia.Templates

# This creates ./ScoutTrainingApp.sln, ./ScoutTrainingApp.Browser/wwwroot/index.html, etc.
dotnet new avalonia.xplat --name ScoutTrainingApp --framework net8.0 --mvvm CommunityToolkit --output .
```

Make sure you can run the desktop with:

```sh
dotnet run --project ScoutTrainingApp.Desktop
```

### 3 - WASM Tools - Administrator Required

The WASM tools are for displaying the app in a web browser. Since this tutorial is web-based with GitHub Codespaces, we need the web browser.

But for running on a local PC, this step is not optional ... you can just run the ScoutTrainingApp.Desktop from the last step.

The following is from <https://docs.avaloniaui.net/docs/guides/platforms/how-to-use-web-assembly>:

```sh
dotnet workload install wasm-tools
```

You won't need Administrator anymore to launch the web app:

```sh
dotnet run --project ScoutTrainingApp.Browser
```

### 4 - Jujutsu

Run:

```powershell
winget install --id=jj-vcs.jj -e
```

## Opening project locally

Download and install **.NET 9.0 STS** from <https://dotnet.microsoft.com/en-us/download>.

Do a:

```sh
# On all PCs except macOS (confer with devcontainer.json's "dotnet restore" notes)
#   And if you have dotnet 8 installed replace [wasm-tools-net8] with [wasm-tools]
dotnet workload install wasm-tools-net8 android
dotnet restore ScoutTrainingApp.Android
dotnet restore ScoutTrainingApp.Browser
dotnet restore ScoutTrainingApp.Desktop

# On macOS
dotnet workload restore
dotnet restore
```

Then on Linux only:

```sh
dotnet dev-certs https
```

Then you can launch the web app:

```sh
dotnet run --project ScoutTrainingApp.Browser
```

## Developing for iOS

The C# extension only scans ScoutTrainingApp.sln which now does not have iOS (and now doesn't have the very annoying error "Failed to restore NuGet packages for the solution." caused by iOS not being installable on non-macOS hardware).

When and if we use iOS for training, the ScoutTrainingApp.sln should be deleted and VS Code restarted.

## To Organize

```sh
xpra start --start='dotnet run --project ScoutTrainingApp.Desktop' --html=on --printing=no --attach=yes --xvfb='Xvfb +extension GLX +extension Composite -screen 0 1024x768x24+32 -nolisten tcp -noreset -auth $XAUTHORITY -dpi 96x96' --resize-display=no --dbus-proxy=no --dbus-control=no --pulseaudio=no --speaker=off --notifications=no --system-tray=no --audio=no --webcam=no --terminate-children=yes --mmap=no --bind-tcp=127.0.0.1:10000 --daemon=yes
```

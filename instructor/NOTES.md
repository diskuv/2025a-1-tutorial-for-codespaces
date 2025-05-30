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

## Outline

1. Environment
2. 1-page 2 fields. [Avalonia Sample: Basic MVVM Sample](https://github.com/AvaloniaUI/Avalonia.Samples/tree/main/src/Avalonia.Samples/MVVM/BasicMvvmSample)
3. 1-page Command. Many fields. [Avalonia Sample: Commands Example](https://github.com/AvaloniaUI/Avalonia.Samples/tree/main/src/Avalonia.Samples/MVVM/CommandSample)
4. 2-page Form Wizard. [Avalonia Sample: Basic ViewLocator Sample](https://github.com/AvaloniaUI/Avalonia.Samples/tree/main/src/Avalonia.Samples/Routing/BasicViewLocatorSample)
5. Complete app with state. [Avalonia Sample: Simple ToDo List](https://github.com/AvaloniaUI/Avalonia.Samples/tree/main/src/Avalonia.Samples/CompleteApps/SimpleToDoList)

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

We want the code to be dotnet 8 since it will be supported longer, so **after the project has been setup** you can also:

1. Install dotnet 9 (they can live side-by-side).
2. Upgrade dotnet 8 to `8.0.410` or later. It is required for the `nuke` tool. Download dotnet 8.0.410 from <https://dotnet.microsoft.com/en-us/download/dotnet/thank-you/sdk-8.0.410-windows-x64-installer>

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

### 4 - jj

If the git repository has not been setup for `jj`, do:

```powershell
# winget publisher moved from martinvonz.jj to jj-vsc.jj.
# confer: https://github.com/microsoft/winget-pkgs/tree/master/manifests/j/jj-vcs/jj/
winget install --id=jj-vcs.jj -e

git pull --ff-only
git switch main

# suggestions prompted during 'jj git init --colocate'
jj git init --colocate
jj bookmark track main@origin
jj config set --user user.name "$(git config get user.name)"
jj config set --user user.email "$(git config get user.email)"
jj config set --user ui.editor "code.cmd -w"
jj describe --reset-author --no-edit

# https://jj-vcs.github.io/jj/latest/windows/#line-endings-are-not-converted
# This will change all endings to LF not CRLF.
git config core.autocrlf input
jj abandon
```

### 5 - dk

Run in PowerShell:

```powershell
mkdir C:\dktutorials
iwr https://diskuv.com/a/dk-distribution/2.3.202505280211/dist/dk-windows_x86_64.exe -OutFile C:\dktutorials\dk.exe
```

Then either:

1. Add the `dk` executable permanently to your environment:

   ```powershell
    $userpath = [System.Environment]::GetEnvironmentVariable("PATH", "USER")
    if (-not ($userpath -like "*\dktutorials")) {
    [Environment]::SetEnvironmentVariable("PATH", $userpath + ";C:\dktutorials", "USER")
    }
   ```

   Then restart VS Code.
2. **OR**, if you have cmake installed, rerun VS Code with:

   ```powershell
   cmake -E env --modify PATH=path_list_prepend:C:\dktutorials -- code
   ```

   each time you need the tutorial.

## Opening project locally

Download and install **.NET 9.0 STS** from <https://dotnet.microsoft.com/en-us/download>.

You will first need a local build of Avalonia which is temporary until <https://github.com/AvaloniaUI/Avalonia/pull/18950> is fixed:

```sh
# (Windows only) Install npm
winget install -e --id OpenJS.NodeJS

git clone https://github.com/jonahbeckford/Avalonia.git ../Avalonia
git -C ../Avalonia reset --hard 71618b9150bf582fd98975d39f6125c3d5417f45
git -C ../Avalonia submodule update --init --recursive
OLDPWD=$(pwd) && cd ../Avalonia
nuke --target BuildToNuGetCache --configuration Debug
cd $OLDPWD
```

For Windows only, did you get the following?

```text
#   [ERR] Compile: C:\Program Files\dotnet\sdk\8.0.410\Sdks\Microsoft.NET.Sdk\targets\Microsoft.NET.Sdk.ImportWorkloads.targets(38,5): error NETSDK1147: To build this project, the following workloads must be installed: tvos [Y:\source\Avalonia\src\iOS\Avalonia.iOS\Avalonia.iOS.csproj::TargetFramework=net8.0-tvos17.0]
#   [ERR] Compile: C:\Program Files\dotnet\sdk\8.0.410\Sdks\Microsoft.NET.Sdk\targets\Microsoft.NET.Sdk.ImportWorkloads.targets(38,5): error NETSDK1147: To install these workloads, run the following command: dotnet workload restore [Y:\source\Avalonia\src\iOS\Avalonia.iOS\Avalonia.iOS.csproj::TargetFramework=net8.0-tvos17.0]
#   [ERR] Compile: C:\Program Files\dotnet\sdk\8.0.410\Sdks\Microsoft.NET.Sdk\targets\Microsoft.NET.Sdk.ImportWorkloads.targets(38,5): error NETSDK1147: To build this project, the following workloads must be installed: tvos [Y:\source\Avalonia\src\iOS\Avalonia.iOS\Avalonia.iOS.csproj::TargetFramework=net8.0-tvos17.0]
#   [ERR] Compile: C:\Program Files\dotnet\sdk\8.0.410\Sdks\Microsoft.NET.Sdk\targets\Microsoft.NET.Sdk.ImportWorkloads.targets(38,5): error NETSDK1147: To install these workloads, run the following command: dotnet workload restore [Y:\source\Avalonia\src\iOS\Avalonia.iOS\Avalonia.iOS.csproj::TargetFramework=net8.0-tvos17.0]
#   [ERR] Compile: Target Compile has thrown an exception
```

Then:

```powershell
del -force -recurse src\iOS\Avalonia.iOS
```

and apply the following patch to `Avalonia.sln`:

```diff
diff --git a/Avalonia.sln b/Avalonia.sln
index a0314b1c3..ca2d0d66d 100644
--- a/Avalonia.sln
+++ b/Avalonia.sln
@@ -58,10 +58,6 @@ Project("{2150E333-8FDC-42A3-9474-1A3956D46DE8}") = "Android", "Android", "{7CF9
 EndProject
 Project("{9A19103F-16F7-4668-BE54-9A1E7A4F7556}") = "Avalonia.Android", "src\Android\Avalonia.Android\Avalonia.Android.csproj", "{7B92AF71-6287-4693-9DCB-BD5B6E927E23}"
 EndProject
-Project("{2150E333-8FDC-42A3-9474-1A3956D46DE8}") = "iOS", "iOS", "{0CB0B92E-6CFF-4240-80A5-CCAFE75D91E1}"
-EndProject
-Project("{9A19103F-16F7-4668-BE54-9A1E7A4F7556}") = "Avalonia.iOS", "src\iOS\Avalonia.iOS\Avalonia.iOS.csproj", "{4488AD85-1495-4809-9AA4-DDFE0A48527E}"
-EndProject
 Project("{9A19103F-16F7-4668-BE54-9A1E7A4F7556}") = "Avalonia.LeakTests", "tests\Avalonia.LeakTests\Avalonia.LeakTests.csproj", "{E1AA3DBF-9056-4530-9376-18119A7A3FFE}"
 EndProject
 Project("{9A19103F-16F7-4668-BE54-9A1E7A4F7556}") = "Avalonia.UnitTests", "tests\Avalonia.UnitTests\Avalonia.UnitTests.csproj", "{88060192-33D5-4932-B0F9-8BD2763E857D}"
```

---

Do a:

```sh
# On all PCs except macOS (confer with devcontainer.json's "dotnet restore" notes)
#   And if you have dotnet 8 installed replace [wasm-tools-net8] with [wasm-tools]
#
#   Temporary until https://github.com/AvaloniaUI/Avalonia/pull/18950:
#   - `dotnet restore` replaced by `dotnet build` to get Avalonia local build
dotnet workload install wasm-tools-net8 android
dotnet build ScoutTrainingApp.Android
dotnet build ScoutTrainingApp.Browser
dotnet build ScoutTrainingApp.Desktop

# On macOS
#
#   Temporary until https://github.com/AvaloniaUI/Avalonia/pull/18950:
#   - `dotnet restore` replaced by `dotnet build` to get Avalonia local build
dotnet workload restore
dotnet build
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

## Avalonia Designer Host App

The default Designer preview does not work in GitHub Codespaces.

That runs:

```sh
dotnet exec --runtimeconfig /workspaces/2025a-1-tutorial-for-codespaces/ScoutTrainingApp.Desktop/bin/Debug/net8.0/ScoutTrainingApp.Desktop.runtimeconfig.json \
   --depsfile /workspaces/2025a-1-tutorial-for-codespaces/ScoutTrainingApp.Desktop/bin/Debug/net8.0/ScoutTrainingApp.Desktop.deps.json \
   /home/vscode/.nuget/packages/avalonia/11.3.0/tools/netstandard2.0/designer/Avalonia.Designer.HostApp.dll \
   --method avalonia-remote \
   --transport tcp-bson://127.0.0.1:8001/ \
   --method html \
   --html-url http://127.0.0.1:8000 \
   /workspaces/2025a-1-tutorial-for-codespaces/ScoutTrainingApp.Desktop/bin/Debug/net8.0/ScoutTrainingApp.Desktop.dll
```

By using the `dotnet exec ... --method avalonia-remote --help` option:

```text
Usage: --transport transport_spec --session-id sid --method method app

--transport: transport used for communication with the IDE
    'tcp-bson' (e. g. 'tcp-bson://127.0.0.1:30243/') - TCP-based transport with BSON serialization of messages defined in Avalonia.Remote.Protocol
    'file' (e. g. 'file://C://my/file.xaml' - pseudo-transport that triggers XAML updates on file changes, useful as a standalone previewer tool, always uses http preview method

--session-id: session id to be sent to IDE process

--method: the way the XAML is displayed
    'avalonia-remote' - binary image is sent via transport connection in FrameMessage
    'win32' - XAML is displayed in win32 window (handle could be obtained from UpdateXamlResultMessage), IDE is responsible to use user32!SetParent
    'html' - Previewer starts an HTML server and displays XAML previewer as a web page

--html-url - endpoint for HTML method to listen on, e. g. http://127.0.0.1:8081

Example: --transport tcp-bson://127.0.0.1:30243/ --session-id 123 --method avalonia-remote MyApp.exe
```

we use the `file` transport instead:

```sh
dotnet exec --runtimeconfig $PWD/ScoutTrainingApp.Desktop/bin/Debug/net8.0/ScoutTrainingApp.Desktop.runtimeconfig.json \
   --depsfile $PWD/ScoutTrainingApp.Desktop/bin/Debug/net8.0/ScoutTrainingApp.Desktop.deps.json \
   /home/vscode/.nuget/packages/avalonia/11.3.0/tools/netstandard2.0/designer/Avalonia.Designer.HostApp.dll \
   --transport file://$PWD/ScoutTrainingApp/App.axaml \
   --method html \
   --html-url http://127.0.0.1:8000 \
   $PWD/ScoutTrainingApp.Desktop/bin/Debug/net8.0/ScoutTrainingApp.Desktop.dll
```

However when a web browser connects it will immediately abort with:

```text
Initializing application in design mode
Obtaining AppBuilder instance from ScoutTrainingApp.Desktop.Program
HtmlTransportStartedMessage
    Uri: http://127.0.0.1:8000/
Triggering XAML update
...
Unhandled exception. System.Exception: Origin doesn't match Url
   at Avalonia.DesignerSupport.Remote.HtmlTransport.HtmlWebSocketTransport.AcceptWorker()
   at System.Threading.Tasks.Task.<>c.<ThrowAsync>b__128_1(Object state)
   at System.Threading.ThreadPoolWorkQueue.Dispatch()
   at System.Threading.PortableThreadPool.WorkerThread.WorkerThreadStart()
```

So we need to have the `--html-url` bind to the correct IP address and port (ex. 127.0.0.1:8000) and the HostApp.dll needs to see the `Host: ...` header from the web browser as `127.0.0.1:8000` -or- the page is a vscode webview (confer: <https://github.com/AvaloniaUI/Avalonia/blob/513d1d96ecdcb121b160b81d412e4ea785c3daae/src/Avalonia.DesignerSupport/Remote/HtmlTransport/HtmlTransport.cs#L137C79-L137C93>).

```sh
dotnet build ScoutTrainingApp.Desktop

dotnet exec --runtimeconfig ScoutTrainingApp.Desktop/bin/Debug/net8.0/ScoutTrainingApp.Desktop.runtimeconfig.json \
   --depsfile ScoutTrainingApp.Desktop/bin/Debug/net8.0/ScoutTrainingApp.Desktop.deps.json \
   /home/vscode/.nuget/packages/avalonia/11.3.0/tools/netstandard2.0/designer/Avalonia.Designer.HostApp.dll \
   --transport file://$PWD/ScoutTrainingApp/App.axaml \
   --method html \
   --transport file://$PWD/ScoutTrainingApp/Views/MainWindow.axaml \
   --method html \
   --transport file://$PWD/ScoutTrainingApp/Views/MainView.axaml \
   --method html \
   --html-url http://127.0.0.1:8000 \
   $PWD/ScoutTrainingApp.Desktop/bin/Debug/net8.0/ScoutTrainingApp.Desktop.dll
```

<!--
That means a reverse proxy from the correct origin (`CODESPACE_NAME-8000.app.github.dev` which is autogenerated and auto-forwarded by GitHub Codespaces) to `127.0.0.1:8000`.
In another terminal we'll start a reverse proxy that can change the `Host` header:

```sh
caddy reverse-proxy \
 --from "http://$CODESPACE_NAME-9000.app.github.dev:9000" \
 --to http://127.0.0.1:8000 \
 --change-host-header
``` -->

## To Organize

An attempt at running the Desktop in an offline X11 buffer and using the display in a web browser:

```sh
xpra start --start='dotnet run --project ScoutTrainingApp.Desktop' --html=on --printing=no --attach=yes --xvfb='Xvfb +extension GLX +extension Composite -screen 0 1024x768x24+32 -nolisten tcp -noreset -auth $XAUTHORITY -dpi 96x96' --resize-display=no --dbus-proxy=no --dbus-control=no --pulseaudio=no --speaker=off --notifications=no --system-tray=no --audio=no --webcam=no --terminate-children=yes --mmap=no --bind-tcp=127.0.0.1:10000 --daemon=yes
```

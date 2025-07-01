# Setup for Windows users

You can always use the GitHub Codespaces tutorial. But you will have a smoother experience using your Windows PC directly. Follow the steps in this document before the tutorial begins.

**ZEROTH**, (yes, there is zero!) ... you have checked out this project (how else are you seeing this?) and are running Visual Studio Code.
Generally that means you have installed Visual Studio Code by clicking the big Windows button on https://code.visualstudio.com/Download, and then have run the following in **PowerShell**:

```sh
if (-not (Test-Path "~/1-tutorial-for-codespaces")) { git -C "$env:USERPROFILE" clone https://gitlab.com/dkml/education/ui-series/2025a/1-tutorial-for-codespaces.git }
code "$env:USERPROFILE/1-tutorial-for-codespaces"
```

**FIRST**, press Ctrl-Shift-P, then `Markdown: Markdown Preview Enhanced: Open Preview to the Side`.

**SECOND**, press Ctrl-Shift-P then `Extensions: Show Recommended Extensions`. Then install all the "WORKSPACE RECOMMENDATIONS" (ignore the OTHER RECOMMENDATIONS).

**THIRD**,

Press Ctrl-Shift-P, then `.NET: Install New .NET SDK`. Then install the Latest `.NET 9`, where you will get a popup that you need to accept.

Again, press Ctrl-Shift-P, then `.NET: Install New .NET SDK`. Then go to the Others tab and install the `.NET 8` (**not** the Latest), where again you will get a popup that you need to accept.

**FOURTH**, go to [Download Node.js](https://nodejs.org/en/download), click `Open` if you get a popup "Do you want Code to open the external website", and then click on the `Windows Installer (.msi)`. Install that with all the default options.

**FIFTH**, exit Visual Studio Code including any other VS Code windows. Then start Visual Studio Code again.

**SIXTH**, open the Terminal (Ctrl-Shift-1) and enter:

```sh
dotnet workload restore
dotnet workload install wasm-tools
dotnet workload install wasm-tools-net8
dotnet workload install android

winget install --id=jj-vcs.jj -e

dotnet tool install --global Nuke.GlobalTool --version 6.2.1

git clone https://github.com/jonahbeckford/Avalonia.git ../Avalonia
git -C ../Avalonia reset --hard 71618b9150bf582fd98975d39f6125c3d5417f45
git -C ../Avalonia submodule update --init --recursive
cd ../Avalonia
(Get-Content Avalonia.sln | ForEach-Object { $_ } | Where-Object { ($_.ReadCount -notin @(61, 62, 63, 64)) }) | Set-Content Avalonia.sln
del -force -recurse src\iOS
del -force -recurse src\Android
~/.dotnet/tools/nuke --target BuildToNuGetCache --configuration Debug
if ($LASTEXITCODE -eq 0) {exit}
```
<!-- INSTRUCTOR COMMENTARY: If you are a student, ignore these 3 lines.
     Lines 61-64 are iOS. Earlier lines are Android (perhaps we could have removed those as well).
     Also, since we delete src/iOS,Android perhaps we did not need to edit Avalonia.sln or install android. -->

**SEVENTH**, exit Visual Studio Code including any other VS Code windows. Then **reboot** and start Visual Studio Code again.

<!-- The reboot is for the Android workload -->

**EIGHTH**, open the Terminal (Ctrl-Shift-1) again and enter:

```sh
dotnet build
```

**LAST**, click on the [TUTORIAL-PC.md](TUTORIAL-PC.md) to start the tutorial with your instructor.

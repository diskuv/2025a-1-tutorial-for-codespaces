# Setup for macOS users

You can always use the GitHub Codespaces tutorial. But you will have a smoother experience using your macOS directly. Follow the steps in this document before the tutorial begins.

**ZEROTH**, (yes, there is zero!) ... you have checked out this project (how else are you seeing this?) and are running Visual Studio Code. Generally that means running the following in your favorite Terminal:

```sh
[ -d ~/1-tutorial-for-codespaces ] || git -C ~ clone https://gitlab.com/dkml/education/ui-series/2025a/1-tutorial-for-codespaces.git
code ~/1-tutorial-for-codespaces
```

**FIRST**, press Cmd-Shift-P, then `Markdown: Markdown Preview Enhanced: Open Preview to the Side`.

**SECOND**, press Cmd-Shift-P then `Extensions: Show Recommended Extensions`. Then install all the "WORKSPACE RECOMMENDATIONS" (ignore the OTHER RECOMMENDATIONS).

**THIRD**,

Press Cmd-Shift-P, then `.NET: Install New .NET SDK`. Then install the Latest `.NET 9`.

Again, press Cmd-Shift-P, then `.NET: Install New .NET SDK`. Then go to the Others tab and install the `.NET 8` (**not** the Latest).

**FOURTH**, go to [Download Node.js](https://nodejs.org/en/download) and click on the `macOS Installer (.pkg)`. Install that.

**FIFTH**, exit Visual Studio Code including any other VS Code windows. Then start Visual Studio Code again.

**SIXTH**, open the Terminal (Ctrl-Shift-1) and enter:

```sh
sudo dotnet workload restore
sudo dotnet workload install wasm-tools
sudo dotnet workload install wasm-tools-net8

wget -O jj.tar.gz https://github.com/jj-vcs/jj/releases/download/v0.29.0/jj-v0.29.0-aarch64-apple-darwin.tar.gz
[ -x /usr/local/bin/jj ] || sudo tar xCfz /usr/local/bin jj.tar.gz ./jj
rm jj.tar.gz

dotnet tool install --global Nuke.GlobalTool --version 6.2.1

git clone https://github.com/jonahbeckford/Avalonia.git ../Avalonia
git -C ../Avalonia reset --hard 71618b9150bf582fd98975d39f6125c3d5417f45
git -C ../Avalonia submodule update --init --recursive
cd ../Avalonia
~/.dotnet/tools/nuke --target BuildToNuGetCache --configuration Debug
exit
```

**SEVENTH**, open the Terminal (Ctrl-Shift-1) again and enter:

```sh
dotnet build
```

**LAST**, click on the [TUTORIAL-PC.md](TUTORIAL-PC.md) to start the tutorial with your instructor.

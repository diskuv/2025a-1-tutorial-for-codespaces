# Debian Bookworm (12) for semantic versions [dotnet.1.x.x]
#   We use .NET 9.0 even though the *.csproj target dotnet8 so
#   the C# extension does not waste time installing 9.0 (apparently
#   the C# language server or whatever uses 9.0).
#
#   NOTE: Instead of a custom Dockerfile, an alternate path could be adding
#   'postCreateCommand' to devcontainer.json. But the C# extension will load in
#   parallel with the 'postCreateCommand', so C# may give a race-condition error
#   "Failed to restore NuGet packages for the solution." since required dotnet
#   workloads have not been installed.
FROM mcr.microsoft.com/devcontainers/dotnet:1-9.0-bookworm

#   wasm-tools-net8: ScoutTrainingApp.Browser (aka.
#       'wasm-tool' if we had dotnet version 8.0 as the dotnet executable)
#   android: ScoutTrainingApp.Android
RUN sudo dotnet workload install wasm-tools-net8 android

#   https://github.com/dotnet/emsdk used by wasm-tools has an
#   implicit system dependency on Python
RUN sudo apt-get update && sudo apt-get install -y python3

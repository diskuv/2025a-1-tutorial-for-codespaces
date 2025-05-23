# Debian Bookworm (12) for semantic versions [dotnet.1.x.x]
#
#   NOTE: Instead of a custom Dockerfile, an alternate path could be adding
#   'postCreateCommand' to devcontainer.json. But the C# extension will load in
#   parallel with the 'postCreateCommand', so C# may give a race-condition error
#   "Failed to restore NuGet packages for the solution." since required dotnet
#   workloads have not been installed.
FROM mcr.microsoft.com/devcontainers/dotnet:1-8.0-bookworm

#   wasm-tools: ScoutTrainingApp.Browser
#   android: ScoutTrainingApp.Android
RUN sudo dotnet workload install wasm-tools android

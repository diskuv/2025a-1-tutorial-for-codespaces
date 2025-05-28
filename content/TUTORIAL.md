# Tutorial

## STEP 1

Double-check that you are inside GitHub Codespaces. Your web browser should be on a page with `https://xxx-xxx-xxxx.github.dev/` in the address bar. If not, start over from the [README.md document](../README.md).

## STEP 2

First, press Ctrl-Shift-B and you should see a `Build.Me` Task running in the bottom right.

Second, click on [ScoutTrainingApp\ViewModels\MainViewModel.cs](../ScoutTrainingApp/ViewModels/MainViewModel.cs) and change the line:

```csharp
private string _greeting = "Welcome to Scout Training!";
```

to

```csharp
private string _greeting = "Welcome to Scout Training YOUR NAME!";
```

## STEP 3

```sh {cmd="cmd" args=["/C", "$input_file"]}
cd ..
.\dk.cmd Send.Me
```

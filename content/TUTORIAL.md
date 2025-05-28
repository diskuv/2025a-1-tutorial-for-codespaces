---
presentation:
  width: 800
  height: 600
---

<!-- slide -->

# Tutorial

## STEP 1

**Verify:**

- [ ] that you are inside GitHub Codespaces. Your web browser (the `ScoutTrainingApp.Browser` tab on the right hand side) should be on a page with `https://xxx-xxx-xxxx.github.dev/` in the address bar. If not, start over from the [README.md document](../README.md).

<!-- slide -->

## STEP 2

First, press Ctrl-Shift-B and you should see a `Build.Me` Task running in the bottom right.

Second, click on [ScoutTrainingApp\ViewModels\MainViewModel.cs](../ScoutTrainingApp/ViewModels/MainViewModel.cs) and change the line:

```csharp
private string _greeting = "Welcome to Scout Training!";
```

to the following (replace *YOUR FIRST NAME* with your real first name!):

```csharp
private string _greeting = "Welcome to Scout Training, YOUR FIRST NAME!";
```

**Verify:**

- [ ] within 30 seconds you see the change in the `ScoutTrainingApp.Browser` tab on the right hand side.

<!-- slide -->

## STEP 3

```sh {cmd="cmd" args=["/C", "$input_file"]}
..\dk.cmd Send.Me
```

**Verify:**

- [ ] you see and have followed the instruction `Paste this link in the chat window`.
- [ ] your instructor tells you they received your changes.

using CommunityToolkit.Mvvm.ComponentModel;

namespace ScoutTrainingApp.ViewModels;

public partial class MainViewModel : ViewModelBase
{
    [ObservableProperty]
    private string _greeting = "Welcome to Scout Training!";
}

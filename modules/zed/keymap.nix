[
  {
    context = "Workspace";
    bindings = {
      "ctrl-t" = "terminal_panel::ToggleFocus";
      "alt" = [
        "app_menu::OpenApplicationMenu"
        "Zed"
      ];
    };
  }
  {
    context = "Terminal";
    bindings = {
      "ctrl-n" = "workspace::NewTerminal";
      "ctrl-w" = "pane::CloseActiveItem";
    };
  }
]

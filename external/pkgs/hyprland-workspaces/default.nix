{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "hyprland-workspaces";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "TotalTaxAmount";
    repo = "hyprland-workspaces";
    rev = "0a3febcb1700ad99bcb25515b4d2175b62b524fa";
    hash = "sha256-xPp1nyne+4anTbEc/NN7WVY0mgCxxUpitlZDgN915n0=";
  };

  cargoHash = "sha256-AT3K6trQ2i5KihWbRnSv+jJggygnj4/B9Oncme4VkC4=";

  meta = with lib; {
    description = "Multi-monitor aware Hyprland workspace widget";
    homepage = "https://github.com/FieldofClay/hyprland-workspaces";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ kiike donovanglover ];
    mainProgram = "hyprland-workspaces";
  };
}

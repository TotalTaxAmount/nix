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
    rev = "c2946255dbc175ca1127b2c4b1cb5d02ac35df06";
    hash = "sha256-CDGeXttiI0b2X2wOIkqvljPVExhlSqsBvHWJB1RbgnY=";
  };

  cargoHash = "sha256-AT3K6trQ2i5KihWbRnSv+jJggygnj4/B9Oncme4VkC4=";

  meta = with lib; {
    description = "Multi-monitor aware Hyprland workspace widget";
    homepage = "https://github.com/FieldofClay/hyprland-workspaces";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ donovanglover ];
    mainProgram = "hyprland-workspaces";
  };
}
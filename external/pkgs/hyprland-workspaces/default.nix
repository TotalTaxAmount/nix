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
    rev = "24a72e2f530aa4fb4e7b13bdff1f2b7e5b3ad88c";
    hash = "sha256-GsZtIWh+7HTc0nUhxktC3y5V64+lbSbpwPYbjJCMJ00=";
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

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
    rev = "f33d0d60c1d3bb263bd0977b4d4ae1b85c562924";
    hash = "sha256-6IWUwx0a2SMxFWbRxi1VND80kHRyaKAQAh86Y3rmbCQ=";
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

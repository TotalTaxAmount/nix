{pkgs}:

{
  pkgs.appimageTools.warpType1 {
    name = "Flight Core";
    src = builtins.fetchTarball {
      src = "https://github.com/R2NorthstarTools/FlightCore/releases/download/v2.10.0/flight-core_2.10.0_amd64.AppImage";
    };
  };
}
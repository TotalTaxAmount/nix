final: prev:
{
  discord = prev.discord.override {
    withVencord = true;
  };

  eww = prev.eww.override  {
    withWayland = true;
  };

  btop = prev.btop.overrideAttrs (old: {
    src = prev.fetchFromGitHub {
      owner = "romner-set";
      repo = "btop-gpu";
      rev = "2378dd4a96883205729879df217f862280129ad0";
      hash = "sha256-5Xe13O0FL70V9O72KhuLbaAPo0DaKL9XXWJoAj0YEQY=";
    };

    # Add fmt
    buildInputs = old.buildInputs ++ [ prev.fmt ];

     # Set LD_LIBRARY_PATH to include NVIDIA library path
    nativeBuildInputs = [ prev.writeText "set-ld-library-path.sh" ''
      export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/run/opengl-driver/lib
    '' ];

    # Modify the startCmd to run btop with the environment variable
    startCmd = "${prev.fmt}/bin/fmt ${prev.btop}/bin/btop";
  });
}
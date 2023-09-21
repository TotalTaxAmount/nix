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

    buildInputs = old.buildInputs ++ [ prev.fmt ];
    nativeBuildInputs = [ prev.rocm-smi ];

   # buildFlags = [ "RSMI_STATIC=true" ];
    
  });
}
{ pkgs }:
{
  nil = {
    binary = {
      path = "${pkgs.nil}/bin/nil";
    };
    settings = {
      diagnostics = {
        ignored = [
          "unused_binding"
        ];
      };
    };
  };

  jdtls = {
    settings = {
      java_home = "${pkgs.openjdk21}";
      import = {
        gradle.enable = true;
      };
    };
  };
}

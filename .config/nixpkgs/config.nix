{ 
    allowUnfree = true;
    packageOverrides = pkgs: with pkgs; rec {
        stm-dev-env = pkgs.buildEnv {
          name = "stm-dev-env";
          paths = with pkgs; [
            gcc-arm-embedded
            openocd
            ninja
            cmake
          ];
        };
    };
}

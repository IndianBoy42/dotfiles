{ 
    allowUnfree = true;
    packageOverrides = pkgs: with pkgs; rec {
        common-dev-tools = pkgs.buildEnv {
          name = "common-dev-tools";
          paths = with pkgs; [
            ninja
            cmake
          ];
        };
        stm-dev = pkgs.buildEnv {
          name = "stm-dev";
          paths = with pkgs; [
            gcc-arm-embedded
            openocd
            common-dev-tools
          ];
        };
        cpp-dev = pkgs.buildEnv {
          name = "cpp-dev";
          paths = with pkgs; [
            binutils
            clang
            gcc
            lld
            gold
            common-dev-tools
          ];
        };
        py-dev = pkgs.buildEnv {
          name = "cpp-dev";
          paths = with pkgs; [
            python
            poetry
            black
            ipython
          ];
        };
        clitools = pkgs.buildEnv {
          name = "cli-tools";
          paths = with pkgs; [
            bat
            gh
            #kn
            zoxide
            lsd
            bottom
            fd-find
            git-delta
            fzf
            broot
            ripgrep
            gitui
            du-dust
            watchexec
            pueue
            tealdeer
            zstd
            jq
            xsv
            duma
            huniq
            hyperfine
            pipe-rename
          ];
        };
        utilities = pkgs.buildEnv {
          name = "utilities";
          paths = with pkgs; [
            cli-tools
            tectonic
            alacritty
            spotify-tui
          ];
        };
    };
}

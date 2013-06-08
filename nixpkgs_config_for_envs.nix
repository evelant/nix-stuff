#This file specifies "custom" packages in the nix store... stuff for our system but that we don't want to 
#share with the main nixpkgs repo
{
  packageOverrides = pkgs : with pkgs; {
    # allows us to run "load-env-node" and have an environment to develop nodejs in
    # sets npm to globally install packages in home folder so we can use npm without translating packages to nix
    nodeEnv = pkgs.myEnvFun {
        name = "node";
        buildInputs = [ stdenv python nodejs ];
        extraCmds = ''
            npm config set prefix ~/.nodejs
            export PATH=$PATH:${builtins.getEnv "HOME"}/.nodejs/bin
        '';
    };

    # same as above but for installing RVM so we can develop in ruby with all gems outside of nix, does not work well yet
    rvmEnv = pkgs.myEnvFun {
      name = "rvm";
      buildInputs = [ stdenv zlib openssl libxml2 libxslt libiconv ];
      extraCmds = ''
        unset http_proxy 
        unset ftp_proxy
        export LIBXML2_DIR=${libxml2}
        export LIBXSLT_DIR=${libxslt}
        export LIBICONV_DIR=${libiconv}
      '';
    };
  };
}

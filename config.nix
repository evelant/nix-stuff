{
  allowUnfree = true;
  vim.ruby = true;
  allowBroken = true;
  packageOverrides = pkgs : with pkgs; {
    rvmEnv = pkgs.myEnvFun {
      name = "rvm";
      buildInputs = [ stdenv  python pythonPackages.boto procps which libyaml readline zlib openssl libxml2 libxslt libiconv ];
      extraCmds = ''
        unset http_proxy
        unset ftp_proxy
        export LIBXML2_DIR=${libxml2}
        export LIBXSLT_DIR=${libxslt}
        export LIBICONV_DIR=${libiconv}
        export OPENSSL_DIR=${openssl}
        export READLINE_DIR=${readline}
        export LIBYAML_DIR=${libyaml}
        export LOCAL_REDIS=true
        #bash --login
        . ~/.rvm/scripts/rvm
        #rvm use ruby
      '';
    };
  };
}
# to install fucking nokogiri
#gem install nokogiri -- --use-system-libraries --with-xml2-include=$LIBXML2_DIR/include/libxml2 --with-xml2-lib=$LIBXML2_DIR/lib --with-xslt-dir=$LIBXSLT_DIR --with-iconv-include=$LIBICONV_DIR/include --with-iconv-lib=$LIBICONV_DIR/lib


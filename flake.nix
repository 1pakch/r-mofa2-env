{
  description = "R with MOFA2 and tidyverse";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    mofapy2-env.url = "github:1pakch/mofapy2-env";
  };

  outputs = { self, nixpkgs, mofapy2-env }: let

    pkgs = nixpkgs.legacyPackages.x86_64-linux;

    # Python env with `mofapy2` package available
    py-env = mofapy2-env.packages.x86_64-linux.default;

    # R env with `MOFA2` package and its R deps
    r-env = pkgs.rWrapper.override {
      packages = [
        pkgs.rPackages.IRkernel
        pkgs.rPackages.MOFA2
        pkgs.rPackages.tidyverse
        pkgs.rPackages.DESeq2
      ];
    };

    # A shell script that launches the R as per above and
    # additionally sets `MOFAPY2_PYTHON_PATH` env variable
    # so that one can do
    # ```
    #   reticulate::use_python(Sys.getenv("MOFA2_PYTHON_PATH"))
    #   run_mofa(...)
    # ```
    r-env-with-py-env = pkgs.writeShellScriptBin "R" ''
      MOFAPY2_PYTHON_PATH="${py-env}/bin/python3" ${r-env}/bin/R $@
    '';

    flakeApp = path: { type = "app"; program = path; };

  in {

    packages.x86_64-linux.default = r-env-with-py-env;

    apps.x86_64-linux.default = (flakeApp "${r-env-with-py-env}/bin/R");

  };
}

{
  description = "R with MOFA2 and tidyverse";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = { self, nixpkgs }: let
    pkgs = nixpkgs.legacyPackages.x86_64-linux;
    r-env = pkgs.rWrapper.override {
      packages = [
        pkgs.rPackages.IRkernel
        pkgs.rPackages.MOFA2
        pkgs.rPackages.tidyverse
      ];
    };
    flakeApp = path: { type = "app"; program = path; };
  in {
    apps.x86_64-linux.R = flakeApp "${r-env}/bin/R";
    packages.x86_64-linux.default = r-env;
  };
}

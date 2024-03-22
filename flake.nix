{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };
  outputs = {nixpkgs, ...}: let
    inherit (nixpkgs) lib;
    withSystem = f:
      lib.fold lib.recursiveUpdate {}
      (map f ["x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin"]);
  in
    withSystem (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
        inherit (pkgs) python3;
        nodejs-bin = pkgs.callPackage ./nodejs-bin {inherit python3;};
        basedpyright = python3.pkgs.buildPythonPackage {
          pname = "basedpyright";
          version = "1.6.1";
          format = "wheel";
          src = pkgs.fetchurl {
            url = "https://files.pythonhosted.org/packages/35/64/a0c23a5cb0fee6f860feb221027ff95c7b00d41992438a41f3a816c99794/basedpyright-1.6.1-py3-none-any.whl";
            hash = "sha256-NUOeJY8wbJcWotohCi6BCo49GU8+JIOA4tJsuvEtDss=";
          };
          propagatedBuildInputs = [nodejs-bin];
        };
      in
        with pkgs; {
          packages.${system}.default = basedpyright;
          apps.${system} = {
            default = {
              type = "app";
              program = "${basedpyright}/bin/basedpyright";
            };
            language-server = {
              type = "app";
              program = "${basedpyright}/bin/basedpyright-langserver";
            };
          };
          devShells.${system}.default =
            mkShell {packages = [basedpyright];};
        }
    );
}

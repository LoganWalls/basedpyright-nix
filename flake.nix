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
          version = "1.12.2";
          format = "wheel";
          src = pkgs.fetchurl {
            url = "https://files.pythonhosted.org/packages/0f/fa/9a358a171581c3452cd933f08a3ad7501acbe0ab4ec1acb894c7bb08b2fc/basedpyright-1.12.2-py3-none-any.whl";
            hash = "sha256-l/O/Juys9hHZMYMCKtoLu+8hhDOMsZPsRwJyPbOdTFE=";
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

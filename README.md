# Usage
This flake packages [basedpyright](https://github.com/DetachHead/basedpyright).

Run type checker:
```sh
nix run "github:LoganWalls/basedpyright-nix"
```

Run language server:
```sh
nix run "github:LoganWalls/basedpyright-nix#language-server"
```

Use it in a temporary shell:
```sh
nix shell "github:LoganWalls/basedpyright-nix"
basedpyright
basedpyright-langserver
```

Use it as a flake input:
```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    basedpyright-nix = {
        url = "github:LoganWalls/basedpyright-nix";
        inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = {nixpkgs, basedpyright-nix, ...}: let
    inherit (nixpkgs) lib;
    withSystem = f:
      lib.fold lib.recursiveUpdate {}
      (map f ["x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin"]);
  in
    withSystem (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
        basedpyright = inputs.basedpyright.packages.${system}.default;
      in
        with pkgs; {
          devShells.${system}.default =
            mkShell {packages = [basedpyright];};
        }
    );
};
```


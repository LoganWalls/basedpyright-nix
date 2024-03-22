{
  python3,
  nodejs,
  nodePackages,
}: let
  inherit (python3.pkgs) buildPythonPackage;
  inherit (nodePackages) npm;
in
  buildPythonPackage {
    pname = "nodejs-bin";
    version = "18.4.0a4";
    src = ./src;
    pyproject = true;
    buildInputs = [python3.pkgs.setuptools];
    postConfigure = ''
      substituteInPlace nodejs/node.py --replace-fail 'bin/node' '${nodejs}/bin/node'
      substituteInPlace nodejs/npm.py --replace-fail 'lib/node_modules/npm/bin/npm-cli.js' '${npm}/bin/npm'
      substituteInPlace nodejs/npx.py --replace-fail 'lib/node_modules/npm/bin/npx-cli.js' '${npm}/bin/npx'
      substituteInPlace nodejs/corepack.py --replace-fail 'lib/node_modules/corepack/dist/corepack.js' '${nodejs}/bin/corepack'
    '';
  }

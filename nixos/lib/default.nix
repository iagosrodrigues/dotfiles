{inputs}: let
  lib = inputs.nixpkgs.lib;

  scanPaths = dir: type:
    if lib.pathExists dir
    then let
      items = builtins.readDir dir;
    in
      lib.filterAttrs (n: t: t == type) items
    else {};

  discoverModules = dir:
    if !lib.pathExists dir
    then {}
    else let
      files = scanPaths dir "regular";
      dirs = scanPaths dir "directory";

      mkModule = name: path: {
        name = lib.removeSuffix ".nix" name;
        value = path;
      };

      nixFiles = lib.filterAttrs (n: _: lib.hasSuffix ".nix" n) files;

      validDirs = lib.filterAttrs (n: _: lib.pathExists (dir + "/${n}/default.nix")) dirs;

      moduleFiles = lib.mapAttrsToList mkModule nixFiles;

      moduleDirs =
        lib.mapAttrsToList (name: _: {
          name = name;
          value = dir + "/${name}/default.nix";
        })
        validDirs;
    in
      lib.listToAttrs (
        map (m: {
          name = m.name;
          value = m.value;
        }) (moduleFiles ++ moduleDirs)
      );

  mapPackages = dir:
    if !lib.pathExists dir
    then {}
    else let
      files = scanPaths dir "regular";
      dirs = scanPaths dir "directory";

      mkPackage = name: path: {
        name = lib.removeSuffix ".nix" name;
        value = path;
      };

      packageNixFiles = lib.filterAttrs (n: _: lib.hasSuffix ".nix" n && n != "default.nix") files;

      packageDirs =
        lib.mapAttrsToList (name: _: {
          name = name;
          value = dir + "/${name}";
        })
        dirs;

      packageFiles = lib.mapAttrsToList mkPackage packageNixFiles;
      allPotentialPackages = packageFiles ++ packageDirs;
    in
      lib.listToAttrs (
        map (p: {
          name = p.name;
          value = import p.value;
        })
        allPotentialPackages
      );

  mapUsers = dir: let
    userDirs = scanPaths dir "directory";
  in
    lib.mapAttrs (
      username: _: let
        userDir = dir + "/${username}";
        defaultNixPath = "${userDir}/default.nix";
        homeNixPath = "${userDir}/home.nix";
      in
        # Cada usuário DEVE ter ambos os arquivos
        if lib.pathExists defaultNixPath && lib.pathExists homeNixPath
        then {
          defaultNixPath = defaultNixPath;
          homeConfigPath = homeNixPath;
        }
        else throw "User directory ${userDir} must contain both default.nix and home.nix"
    )
    userDirs;

  mapHosts = dir: let
    hostDirs = scanPaths dir "directory";
  in
    lib.mapAttrs (
      hostname: _: let
        hostDir = dir + "/${hostname}";
        defaultNixPath = "${hostDir}/default.nix";
        configNixPath = "${hostDir}/configuration.nix";
      in
        if lib.pathExists defaultNixPath && lib.pathExists configNixPath
        then {
          hostAttrs = import defaultNixPath {inherit inputs hostname;};
          mainConfig = configNixPath;
        }
        else throw "Host directory ${hostDir} must contain both default.nix and configuration.nix"
    )
    hostDirs;

  forAllSystems = f:
    lib.listToAttrs (
      map (system: {
        name = system;
        value = f system;
      })
      inputs.nixpkgs.lib.systems.flakeExposed
    );
in {
  inherit
    scanPaths
    discoverModules
    mapPackages
    mapUsers
    mapHosts
    forAllSystems
    ;
}

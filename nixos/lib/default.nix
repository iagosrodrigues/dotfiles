{inputs}: let
  lib = inputs.nixpkgs.lib;

  # ============================================================================
  # FUNÇÕES AUXILIARES
  # ============================================================================

  # Escaneia um diretório e retorna um conjunto de atributos com os itens
  # do tipo especificado (ex: "regular" para arquivos, "directory" para pastas).
  #
  # Parâmetros:
  #   - dir: caminho do diretório a ser escaneado
  #   - type: tipo de item a filtrar ("regular", "directory", etc.)
  #
  # Retorna: conjunto de atributos { nome = tipo; } ou {} se o diretório não existir
  scanPaths = dir: type:
    if lib.pathExists dir
    then let
      items = builtins.readDir dir;
    in
      lib.filterAttrs (n: t: t == type) items
    else {};

  # ============================================================================
  # DESCOBERTA DE MÓDULOS
  # ============================================================================

  # Descobre automaticamente todos os módulos NixOS ou Home Manager em um diretório.
  #
  # Estrutura esperada em modules/nixos/ ou modules/home-manager/:
  #   - Arquivo direto: nome.nix → módulo com nome "nome"
  #   - Diretório com default.nix: pasta/ → módulo com nome "pasta"
  #
  # Exemplo de estrutura:
  #   modules/nixos/
  #     ├── meu-modulo.nix           → módulo "meu-modulo"
  #     └── outro-modulo/
  #         └── default.nix          → módulo "outro-modulo"
  #
  # Parâmetros:
  #   - dir: diretório contendo os módulos (ex: ./modules/nixos)
  #
  # Retorna: conjunto de atributos { nome-do-modulo = <módulo importado>; }
  discoverModules = dir:
    if !lib.pathExists dir
    then {}
    else let
      files = scanPaths dir "regular";
      dirs = scanPaths dir "directory";

      # Função auxiliar para criar entrada de módulo
      mkModule = name: path: {
        name = lib.removeSuffix ".nix" name;
        value = path;
      };

      # Filtra apenas arquivos .nix
      nixFiles = lib.filterAttrs (n: _: lib.hasSuffix ".nix" n) files;

      # Filtra apenas diretórios que contêm default.nix
      validDirs = lib.filterAttrs (n: _: lib.pathExists (dir + "/${n}/default.nix")) dirs;

      # Converte arquivos .nix em lista de módulos
      moduleFiles = lib.mapAttrsToList mkModule nixFiles;

      # Converte diretórios válidos em lista de módulos
      moduleDirs =
        lib.mapAttrsToList (name: _: {
          name = name;
          value = dir + "/${name}/default.nix";
        })
        validDirs;
    in
      # Converte a lista de módulos em um conjunto e importa cada um
      lib.listToAttrs (
        map (m: {
          name = m.name;
          value = import m.value;
        }) (moduleFiles ++ moduleDirs)
      );

  # ============================================================================
  # DESCOBERTA DE PACOTES
  # ============================================================================

  # Descobre automaticamente todos os pacotes personalizados em um diretório.
  #
  # Estrutura esperada em packages/:
  #   - Arquivo .nix (exceto default.nix): meu-pacote.nix → pacote "meu-pacote"
  #   - Diretório: meu-pacote/ → pacote "meu-pacote" (importa o diretório)
  #
  # Exemplo de estrutura:
  #   packages/
  #     ├── meu-pacote.nix          → pacote "meu-pacote"
  #     └── outro-pacote/           → pacote "outro-pacote"
  #         └── default.nix
  #
  # Parâmetros:
  #   - dir: diretório contendo os pacotes (ex: ./packages)
  #
  # Retorna: conjunto de atributos { nome-do-pacote = <função do pacote>; }
  mapPackages = dir:
    if !lib.pathExists dir
    then {}
    else let
      files = scanPaths dir "regular";
      dirs = scanPaths dir "directory";

      # Função auxiliar para criar entrada de pacote
      mkPackage = name: path: {
        name = lib.removeSuffix ".nix" name;
        value = path;
      };

      # Filtra arquivos .nix, excluindo default.nix
      packageNixFiles = lib.filterAttrs (n: _: lib.hasSuffix ".nix" n && n != "default.nix") files;

      # Converte todos os diretórios em pacotes
      packageDirs =
        lib.mapAttrsToList (name: _: {
          name = name;
          value = dir + "/${name}";
        })
        dirs;

      # Combina arquivos e diretórios em uma lista
      packageFiles = lib.mapAttrsToList mkPackage packageNixFiles;
      allPotentialPackages = packageFiles ++ packageDirs;
    in
      # Converte a lista de pacotes em um conjunto e importa cada um
      lib.listToAttrs (
        map (p: {
          name = p.name;
          value = import p.value;
        })
        allPotentialPackages
      );

  # ============================================================================
  # DESCOBERTA DE USUÁRIOS
  # ============================================================================

  # Descobre automaticamente todos os usuários configurados.
  #
  # Estrutura esperada em users/:
  #   users/
  #     └── nome-usuario/
  #         ├── default.nix    → configuração do usuário do sistema (grupos, etc)
  #         └── home.nix       → configuração do Home Manager (programas, etc)
  #
  # Exemplo:
  #   users/
  #     └── joao/
  #         ├── default.nix    → define grupos, shell, etc
  #         └── home.nix       → define programas, configurações do Home Manager
  #
  # Parâmetros:
  #   - dir: diretório contendo os usuários (ex: ./users)
  #
  # Retorna: conjunto de atributos {
  #   nome-usuario = {
  #     defaultNixPath = caminho para default.nix do usuário;
  #     homeConfigPath = caminho para home.nix do usuário;
  #   };
  # }
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

  # ============================================================================
  # DESCOBERTA DE HOSTS (MÁQUINAS)
  # ============================================================================

  # Descobre automaticamente todas as máquinas/hosts configurados.
  #
  # Estrutura esperada em hosts/:
  #   hosts/
  #     └── nome-host/
  #         ├── default.nix          → metadados do host (sistema, módulos extras, etc)
  #         └── configuration.nix    → configuração principal do NixOS
  #
  # Exemplo:
  #   hosts/
  #     └── meu-laptop/
  #         ├── default.nix          → define system = "x86_64-linux", módulos extras
  #         └── configuration.nix    → boot, networking, services, etc modify
  #
  # Parâmetros:
  #   - dir: diretório contendo os hosts (ex: ./hosts)
  #
  # Retorna: conjunto de atributos {
  #   nome-host = {
  #     hostAttrs = resultado de import default.nix (metadados do host);
  #     mainConfig = caminho para configuration.nix;
  #   };
  # }
  mapHosts = dir: let
    hostDirs = scanPaths dir "directory";
  in
    lib.mapAttrs (
      hostname: _: let
        hostDir = dir + "/${hostname}";
        defaultNixPath = "${hostDir}/default.nix";
        configNixPath = "${hostDir}/configuration.nix";
      in
        # Cada host DEVE ter ambos os arquivos
        if lib.pathExists defaultNixPath && lib.pathExists configNixPath
        then {
          hostAttrs = import defaultNixPath {inherit inputs hostname;};
          mainConfig = configNixPath;
        }
        else throw "Host directory ${hostDir} must contain both default.nix and configuration.nix"
    )
    hostDirs;

  # ============================================================================
  # UTILITÁRIOS
  # ============================================================================

  # Aplica uma função para todos os sistemas suportados pelo Nix.
  # Útil para criar pacotes ou formatters que funcionam em múltiplas arquiteturas.
  #
  # Parâmetros:
  #   - f: função que recebe o sistema como parâmetro (ex: system: pkgs.hello)
  #
  # Retorna: conjunto de atributos { x86_64-linux = f "x86_64-linux"; aarch64-linux = f "aarch64-linux"; ... }
  #
  # Exemplo de uso:
  #   forAllSystems (system: legacyPackages.${system}.alejandra)
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

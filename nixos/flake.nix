{
  description = "Main NixOS configuration";

  # ============================================================================
  # INPUTS (ENTRADAS DO FLAKE)
  # ============================================================================
  #
  # Aqui são definidas todas as dependências externas do seu flake.
  # Para adicionar um novo input:
  #   1. Adicione uma entrada no bloco abaixo
  #   2. Execute: nix flake update <nome-do-input>
  #
  inputs = {
    # NixOS oficial (canal instável)
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Fork do nixpkgs com code-cursor em versão específica (PR #456882)
    my-overlays.url = "github:iagosrodrigues/nixpkgs/feature/wivrn";

    # Repositório de pacotes extras da comunidade
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";

    # NUR: Nix User Repository - pacotes da comunidade
    nur.url = "github:nix-community/NUR";

    # Utilitários da comunidade nix-community
    flake-utils.url = "github:numtide/flake-utils";
    rust-overlay.url = "github:oxalica/rust-overlay";

    # Impermanence: permite sistema de arquivos efêmero
    impermanence.url = "github:nix-community/impermanence";

    # Disko: automatiza particionamento e formatação
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Lanzaboote: Secure Boot para NixOS (atualmente comentado)
    # lanzaboote = {
    #   url = "github:nix-community/lanzaboote";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    # Home Manager: gerencia configurações de usuário
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Alejandra: formatador de código Nix
    alejandra = {
      url = "github:kamadorueda/alejandra/4.0.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Hyprland: compositor Wayland
    hyprland = {
      url = "github:hyprwm/Hyprland";
    };

    kwin-effects-forceblur = {
      url = "github:taj-ny/kwin-effects-forceblur";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  # ============================================================================
  # OUTPUTS (SAÍDAS DO FLAKE)
  # ============================================================================
  #
  # Aqui definimos tudo que o flake expõe para uso externo:
  #   - nixosConfigurations: configurações de máquinas NixOS
  #   - nixosModules: módulos NixOS que podem ser reutilizados
  #   - homeModules: módulos do Home Manager que podem ser reutilizados
  #   - packages: pacotes personalizados
  #   - formatter: formatador de código (alejandra)
  #
  outputs = inputs: let
    # Importa funções úteis do Nixpkgs
    inherit (builtins) attrNames attrValues mapAttrs;
    inherit (inputs.nixpkgs) lib legacyPackages;

    # Importa nossa biblioteca local com funções auxiliares
    localLib = import ./lib {inherit inputs;};

    # ========================================================================
    # DESCOBERTA AUTOMÁTICA DE CONFIGURAÇÕES
    # ========================================================================
    #
    # O sistema descobre automaticamente hosts, usuários, módulos e pacotes
    # baseado na estrutura de diretórios. Basta criar os arquivos nos lugares
    # certos e eles serão incluídos automaticamente.

    # Descobre todos os hosts (máquinas) configurados
    # Estrutura esperada: hosts/nome-host/{default.nix, configuration.nix}
    discoveredHosts = localLib.mapHosts ./hosts;

    # Descobre todos os usuários configurados
    # Estrutura esperada: users/nome-usuario/{default.nix, home.nix}
    discoveredUsers = localLib.mapUsers ./users;

    # Descobre todos os módulos NixOS disponíveis
    # Estrutura: modules/nixos/*.nix ou modules/nixos/*/default.nix
    discoveredNixosModules = localLib.discoverModules ./modules/nixos;

    # Descobre todos os módulos Home Manager disponíveis
    # Estrutura: modules/home-manager/*.nix ou modules/home-manager/*/default.nix
    discoveredHomeModules = localLib.discoverModules ./modules/home-manager;

    # Descobre todos os pacotes personalizados
    # Estrutura: packages/*.nix (exceto default.nix) ou packages/*/
    discoveredPackages = localLib.mapPackages ./packages;

    # ========================================================================
    # MÓDULO DE GERAÇÃO DE USUÁRIOS
    # ========================================================================
    #
    # Este módulo NixOS gera automaticamente:
    #   1. Usuários do sistema (users.users.*) a partir de users/*/default.nix
    #   2. Configurações do Home Manager (home-manager.users.*) a partir de users/*/home.nix
    #
    # Para adicionar um novo usuário:
    #   1. Crie: users/seu-usuario/default.nix (define grupos, shell, etc)
    #   2. Crie: users/seu-usuario/home.nix (define programas, configurações)
    #   3. O usuário será incluído automaticamente
    #
    userModule = {
      config,
      pkgs,
      localLib,
      ...
    } @ moduleArgs: {
      # Gera usuários do sistema a partir dos arquivos default.nix
      users.users =
        mapAttrs (
          username: userData: let
            userAttrsFromFile = import userData.defaultNixPath moduleArgs;
          in
            lib.recursiveUpdate userAttrsFromFile {}
        )
        discoveredUsers;

      # Gera configurações do Home Manager a partir dos arquivos home.nix
      home-manager.users =
        mapAttrs (
          username: userData: (import userData.homeConfigPath {
            inherit
              username
              pkgs
              config
              lib
              ;
            hmLib = inputs.home-manager.lib;
          })
        )
        discoveredUsers;

      # Configurações globais do Home Manager
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;

      # Inclui todos os módulos Home Manager descobertos
      home-manager.sharedModules = attrValues discoveredHomeModules;

      # Descomente a linha abaixo para criar backups automáticos do Home Manager
      # home-manager.backupFileExtension = "backup";
    };
  in {
    # ========================================================================
    # EXPORTAÇÕES DO FLAKE
    # ========================================================================

    # Exporta a biblioteca local para uso externo
    lib = localLib;

    # Módulos NixOS disponíveis (incluindo o gerador de usuários)
    nixosModules =
      discoveredNixosModules
      // {
        generateUsers = userModule;
      };

    # Módulos Home Manager disponíveis
    homeModules = discoveredHomeModules;

    # Formatador de código (alejandra) para todas as arquiteturas suportadas
    formatter = localLib.forAllSystems (system: legacyPackages.${system}.alejandra);

    # Pacotes personalizados disponíveis para todas as arquiteturas
    packages = localLib.forAllSystems (
      system: let
        pkgs = legacyPackages.${system};
      in
        # Cada pacote é uma função que recebe { pkgs } e retorna um pacote derivado
        mapAttrs (name: pkgFunc: pkgFunc {inherit pkgs;}) discoveredPackages
    );

    # ========================================================================
    # CONFIGURAÇÕES NIXOS
    # ========================================================================
    #
    # Aqui são geradas as configurações NixOS para cada host descoberto.
    #
    # Para adicionar um novo host/máquina:
    #   1. Crie: hosts/nome-da-maquina/default.nix
    #      Exemplo:
    #        {
    #          inputs, hostname, ...
    #        }: {
    #          system = "x86_64-linux";
    #          modules = [ /* módulos específicos deste host */ ];
    #        }
    #
    #   2. Crie: hosts/nome-da-maquina/configuration.nix
    #      Exemplo:
    #        { config, pkgs, ... }: {
    #          imports = [ /* seus imports */ ];
    #          /* suas configurações */
    #        }
    #
    #   3. O host será incluído automaticamente como nixosConfigurations.nome-da-maquina
    #
    nixosConfigurations =
      mapAttrs (
        hostname: hostData: let
          # Metadados do host (sistema, módulos extras, etc)
          hostAttrs = hostData.hostAttrs;
          system = hostAttrs.system;

          # Argumentos especiais específicos deste host (opcional)
          hostSpecificSpecialArgs = hostAttrs.specialArgs or {};

          # Módulos específicos deste host (opcional)
          hostSpecificModules = hostAttrs.modules or [];

          # Argumentos especiais passados para os módulos
          specialArgs =
            {
              inherit
                hostname
                inputs
                localLib
                system
                ;
            }
            // hostSpecificSpecialArgs;

          # Verifica se há usuários configurados
          hasUsers = lib.length (attrNames discoveredUsers) > 0;
        in
          lib.nixosSystem {
            inherit system specialArgs;

            # Lista de módulos a serem aplicados (em ordem):
            modules =
              # 1. Módulos específicos do host
              hostSpecificModules
              ++ [
                # 2. Configuração principal do host
                hostData.mainConfig
                # 3. Configuração do nixpkgs (overlays, allowUnfree, etc)
                {
                  nixpkgs = {
                    # Permite pacotes não-livres
                    config.allowUnfree = true;

                    # Overlays: modificam ou adicionam pacotes
                    overlays = [
                      # Overlay do NUR (Nix User Repository)
                      inputs.nur.overlays.default

                      # Overlay customizado para usar code-cursor do fork
                      # (necessário enquanto o PR #456882 não é merged)
                      (final: prev: {
                        wivrn = (import inputs.my-overlays {inherit system;}).wivrn;
                      })

                      # Overlay para kwin-effects-forceblur
                      (final: prev: {
                        kwin-effects-forceblur = inputs.kwin-effects-forceblur.packages.${system}.default;
                      })
                    ];
                  };
                }
              ]
              # 4. Módulo padrão do Chaotic (pacotes extras)
              ++ [inputs.chaotic.nixosModules.default]
              # 5. Todos os módulos NixOS descobertos automaticamente
              ++ (attrValues discoveredNixosModules)
              # 6. Integração com Home Manager (se houver usuários)
              ++ (lib.optionals hasUsers [
                inputs.home-manager.nixosModules.home-manager
                userModule
              ]);
          }
      )
      discoveredHosts;
  };
}

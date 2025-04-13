{
  stdenv,
  lib,
  gtk3,
  nss,
  coreutils,
  webkitgtk_4_0,
  libappindicator,
  autoPatchelfHook,
  pkgs ? import <nixpkgs> {},
}: let
  runFile = pkgs.fetchurl {
    url = "https://download-lojasrenner.eu.goskope.com/dlr/linux/get";
    sha256 = "120ldp181cdlplfg1xlbifal6ip060pcnpsmmwr7hzm3ckbmgzmd"; # Gere com `nix-prefetch-url <URL>`
  };

  packageVersion = pkgs.lib.removeSuffix "\n" (builtins.readFile (pkgs.runCommand "extract-version" {
      buildInputs = with pkgs; [coreutils];
    } ''
      grep "version=" ${runFile} | cut -d'=' -f2 | tr -d '"' > $out
    ''));

  outputDir = "./extracted_netskope";
in
  stdenv.mkDerivation {
    name = "netskope-client";
    version = packageVersion;
    src = runFile;

    nativeBuildInputs = [autoPatchelfHook];
    buildInputs = [coreutils gtk3 libappindicator nss webkitgtk_4_0];

    dontUnpack = true;
    dontConfigure = true;
    buildPhase = ''
      filesize=$(grep -a "filesizes=" "$src" | cut -d'=' -f2 | sed 's/"//g')
      offset_cmd=$(grep -E -a "^offset=\`head -n" "$src")
      adjusted_cmd=$(echo "$offset_cmd" | sed "s|\$0|$src|g")
      eval "$adjusted_cmd"

      echo "Filesize = $filesize"
      echo "Offset CMD = $adjusted_cmd"
      echo "Offset = $offset"
      echo "${outputDir}"

      mkdir -p "${outputDir}"

      tail -c +"$((offset + 1))" "$src" | head -c "$filesize" \
        | gzip -cd \
        | (cd "${outputDir}"; tar xf -)
    '';

    installPhase = ''
      runHook preInstall
      appPath="$out/opt/netskope/stagent"

      mkdir -pm755 $out/bin
      mkdir -pm755 $appPath/data
      mkdir -pm755 $appPath/scripts
      mkdir -pm755 $appPath/resources
      mkdir -pm755 $appPath/resources/idpServiceProviderPages

      cd "${outputDir}"

      install -Dm755 certutil -t $appPath
      install -Dm755 nsdiag -t $appPath
      install -Dm755 stAgentApp -t $appPath
      install -Dm755 stAgentCli -t $appPath
      install -Dm755 stAgentSvc -t $appPath
      install -Dm755 stAgentUI -t $appPath
      install -Dm755 gpgverify.sh -t $appPath/scripts
      install -Dm755 stagentd_pre_exec.sh -t $appPath/scripts

      install -Dm644 nsclient-pub.gpg -t $appPath/scripts
      install -Dm644 stagentd.service -t $appPath/scripts
      install -Dm644 stagentapp.service -t $appPath/scripts
      install -Dm644 stagentui.desktop -t $appPath/scripts

      patchShebangs --host $appPath/scripts/gpgverify.sh
      patchShebangs --host $appPath/scripts/stagentd_pre_exec.sh

      substituteInPlace $appPath/scripts/gpgverify.sh \
        --replace /opt/ $out/opt/
      substituteInPlace $appPath/scripts/stagentapp.service \
        --replace /opt/ $out/opt/
      substituteInPlace $appPath/scripts/stagentd.service \
        --replace /opt/ $out/opt/
      substituteInPlace $appPath/scripts/stagentui.desktop \
        --replace /opt/ $out/opt/

      cp -f resources/*.html $appPath/resources
      cp -f resources/*.ico  $appPath/resources
      cp -f resources/*.png  $appPath/resources
      cp -f resources/idpServiceProviderPages/*.html \
        $appPath/resources/idpServiceProviderPages

      find $appPath/resources -type f | xargs chmod 644

      install -Dm444 $appPath/scripts/stagentd.service -t $out/lib/systemd/system
      install -Dm444 $appPath/scripts/stagentapp.service -t $out/lib/systemd/user
      install -Dm444 $appPath/scripts/stagentui.desktop -t $out/share/applications

      mkdir -pm755 $out/bin
      ln -s $appPath/stAgentCli $out/bin/nsclient

      runHook postInstall
    '';

    meta = {
      description = "Netskope Client";
      homepage = "https://www.netskope.com/netskope-one";
      license = lib.licenses.unfree;
      platforms = lib.platforms.linux;
      mainProgram = "nsclient";
    };
  }

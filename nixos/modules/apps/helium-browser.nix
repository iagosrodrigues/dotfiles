_:
let
  heliumBrowserPackage =
    {
      stdenv,
      lib,
      appimageTools,
      fetchurl,
      makeDesktopItem,
      copyDesktopItems,
    }:
    let
      pname = "helium-browser";
      version = "0.9.4.1";

      architectures = {
        x86_64-linux = {
          arch = "x86_64";
          hash = "sha256-N5gdWuxOrIudJx/4nYo4/SKSxakpTFvL4zzByv6Cnug=";
        };
        aarch64-linux = {
          arch = "arm64";
          hash = "sha256-BvU0bHtJMd6e09HY+9Vhycr3J0O2hunRJCHXpzKF8lk=";
        };
      };

      release =
        architectures.${stdenv.hostPlatform.system}
          or (throw "Unsupported system for helium-browser: ${stdenv.hostPlatform.system}");

      src = fetchurl {
        url = "https://github.com/imputnet/helium-linux/releases/download/${version}/helium-${version}-${release.arch}.AppImage";
        hash = release.hash;
      };
    in
    appimageTools.wrapType2 {
      inherit pname version src;
      nativeBuildInputs = [ copyDesktopItems ];

      desktopItems = [
        (makeDesktopItem {
          name = pname;
          desktopName = "Helium Browser";
          exec = pname;
          icon = pname;
          categories = [
            "Network"
            "WebBrowser"
          ];
          startupWMClass = "helium";
        })
      ];

      meta = with lib; {
        description = "Privacy-focused browser built from Chromium";
        homepage = "https://github.com/imputnet/helium-linux";
        license = licenses.unfree;
        mainProgram = pname;
        platforms = attrNames architectures;
        sourceProvenance = [ sourceTypes.binaryNativeCode ];
      };
    };
in
{
  flake.modules.nixos.helium-browser =
    { pkgs, ... }:
    {
      environment.systemPackages = [ (pkgs.callPackage heliumBrowserPackage { }) ];
    };

  flake.modules.homeManager.helium-browser =
    { pkgs, ... }:
    {
      home.packages = [ (pkgs.callPackage heliumBrowserPackage { }) ];
    };
}

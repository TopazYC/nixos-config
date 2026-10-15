{
  config,
  lib,
  pkgs,
  ...
}:
let
  frpc = pkgs.stdenvNoCC.mkDerivation {
    pname = "sakurafrp-frpc";
    version = "0.51.0-sakura-15"; # 用实际版本
    src = pkgs.fetchurl {
      url = "https://nya.globalslb.net/natfrp/client/frpc/0.51.0-sakura-15/frpc_linux_amd64";
      hash = "sha256-UsGlPnY/F9M/GzRmHkKDvGdJeXdLRY9VaOmXOtHmipk=";
    };
    dontUnpack = true; # 就是个裸二进制
    installPhase = "install -Dm755 $src $out/bin/frpc";
  };
in
{
  environment.systemPackages = [ frpc ];

  #systemd.services.sakura-frp = {
  #description = "SakuraFrp frpc client";
  #after = [ "network-online.target" ];
  #wants = [ "network-online.target" ];
  #wantedBy = [ "multi-user.target" ];
  #serviceConfig = {
  ## 访问密钥从 sops 读，别写进 ExecStart 字面量
  #ExecStart = "${pkgs.writeShellScript "sakura-frp-start" ''
  #exec ${frpc}/bin/frpc -f "$(cat ${config.sops.secrets.sakura_frp_key.path})"
  #''}";
  #Restart = "always";
  #RestartSec = 5;
  #};
  #};
}

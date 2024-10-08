{ config, pkgs, lib, ... }: {

  security.polkit.enable = true;

  systemd.extraConfig = "DefaultLimitNOFILE=4096";

  services = {
    xserver.enable = true;
    displayManager.sddm.enable = true;
    displayManager.sddm.wayland.enable = true;
  };

  xdg.portal.enable = true;

  programs.river = {
    enable = true;
    xwayland.enable = true;

    extraPackages = with pkgs; [
      kanshi
    ];
  };
}

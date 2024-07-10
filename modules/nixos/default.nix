{
  pkgs,
  lib,
  config,
  myVars,
  ...
}:
with lib; let
  cfgWayland = config.modules.desktop.wayland;
  cfgXorg = config.modules.desktop.xorg;
in {
  imports = [
    ./base
    ../base.nix

    #./desktop
  ];

  options.modules.desktop = {
    wayland = {
      enable = mkEnableOption "Wayland Display Server";
    };
    xorg = {
      enable = mkEnableOption "Xorg Display Server";
    };
  };

  config = mkMerge [
    (mkIf cfgWayland.enable {
      ####################################################################
      #  NixOS's Configuration for Wayland based Window Manager
      ####################################################################
      xdg.portal = {
        enable = true;
        wlr.enable = true;
        extraPortals = with pkgs; [
          xdg-desktop-portal-wlr
        ];
      };

      services = {
        xserver.enable = true;

        greetd = {
          enable = true;
          settings = {
            default_session = {
              # Wayland Desktop Manager is installed only for user ruan via home-manager!
              user = myVars.username;

              # .wayland-session is a script generated by home-manager, which links to the current wayland compositor(sway/hyprland or others).
              # with such a vendor-no-locking script, we can switch to another wayland compositor without modifying greetd's config here.
              command = "$HOME/.wayland-session"; # start a wayland session directly without a login manager
              # command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd $HOME/.wayland-session";  # start wayland session with a TUI login manager
            };
          };
        };
      };
     })

    (mkIf cfgXorg.enable {
      ####################################################################
      #  NixOS's Configuration for Xorg Server
      ####################################################################
      services = {
        # TODO???
        xserver = {
          enable = true;
        };

      };
     })
  ];
}

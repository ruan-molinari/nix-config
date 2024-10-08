{ config
, pkgs
, ...
}: {
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  services.mpd.enable = true;

  environment.systemPackages = with pkgs; [
    alsa-utils
    mpc-cli
  ];
}

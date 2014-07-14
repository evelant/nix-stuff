# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      # enable virtualbox
      <nixos/modules/programs/virtualbox.nix>
    ];

  # Use the gummiboot efi boot loader.
  boot.loader.gummiboot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

   networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless.
    networking.networkmanager.enable = true;
    networking.firewall.enable = false;
    networking.firewall.allowedTCPPorts = [ 53 88 135 137 138 139 445 389 901 464 636 3268 3269 5353];
    networking.firewall.allowedUDPPorts = [ 53 88 136 138 139 389 464 5353 ];
    networking.firewall.allowedTCPPortRanges = [{ from = 1713; to = 1765; } { from = 1024; to = 5000; }];
    networking.firewall.allowedUDPPortRanges = [{ from = 1713; to = 1765; }];

  # Select internationalisation properties.
  # i18n = {
  #   consoleFont = "lat9w-16";
  #   consoleKeyMap = "us";
  #   defaultLocale = "en_US.UTF-8";
  # };

    time.timeZone = "America/New_York";

    hardware.pulseaudio.enable = true;
    hardware.bluetooth.enable = true;

    #allow unfree software
    nixpkgs.config.allowUnfree = true;

    nixpkgs.config.packageOverrides = pkgs :
    {
        #jdk = pkgs.oraclejdk;
        #jre = pkgs.oraclejre;
        wine = pkgs.wineUnstable;
    };

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
   environment.systemPackages = with pkgs; [
     
     wget
     gparted
     vim
     git
     jdk
     steamChrootEnv
     which
     firefoxWrapper
     chromiumWrapper
     google_talk_plugin
     oxygen_gtk
     nodejs
     unzip
     dropbox
     dropbox-cli
     keepass
     skype
     net_snmp
     kde4.networkmanagement
     kde4.kdemultimedia
     kde4.kdegraphics
     kde4.kdelibs
     kde4.kdenetwork
     kde4.kdeutils
     kde4.kdeadmin
     kde4.kdebindings
     kde4.kdeartwork
     kde4.kde_baseapps
     kde4.kdeplasma_addons
     kde4.kde_wallpapers
     kde4.bluedevil
     kde4.kdiff3
     kde4.amarok
#     kde4.kipi_plugins
     kde4.partitionManager
     kde4.kmix
     kde4.semnotes
     kde4.kactivities
     kde4.print_manager
     kde4.kdeconnect
     kde4.kdepim
     kde4.akonadi #required by kmail in kdepim
#    sshfsFuse required for remote filesystem on kdeconnect
     kde4.ktorrent
     thunderbird
     sshfsFuse
     flashplayer
     gnupg
     lftp
     bashCompletion
     wine
     winetricks
     glxinfo
     kde4.yakuake
     awscli 
#    xsel must be installed to copy paste text out of keepass, should add it to keepass deps
     xsel
     dfeet
   ];

   nixpkgs.config.chromium.enablePepperFlash = true;
   nixpkgs.config.chromium.enableGoogleTalkPlugin = true;
   nixpkgs.config.firefox.enableAdobeFlash = true;
   nixpkgs.config.firefox.enableGoogleTalkPlugin = true;

   services.locate.enable = true;
   services.printing.enable = true;
   services.printing.cupsdConf = ''
    BrowseRemoteProtocols all
   '';

   #databases for rails development
   services.mongodb.enable = true;
   services.elasticsearch.enable = true;
   services.mysql.enable = true; #for akonadi an kde see https://github.com/NixOS/nixpkgs/issues/1053
   services.mysql.package = pkgs.mysql55;
   services.redis.enable = true;

   #samba for windows filesharing
   services.samba.enable = true;
   services.samba.securityType = "share";
   services.samba.extraConfig = ''
    workgroup = WORKGROUP
    server string = smbnix
    netbios name = smbnix
    security = share
    use sendfile = yes

    [rw-files]
    comment = Imagio Share
    path = /home/imagio/shared
    read only = no
    writable = yes
    public = yes
   '';

   environment.shellInit = ''
    export GTK_PATH=$GTK_PATH:${pkgs.oxygen_gtk}/lib/gtk-2.0
    export GTK2_RC_FILES=$GTK2_RC_FILES:${pkgs.oxygen_gtk}/share/themes/oxygen-gtk/gtk-2.0/gtkrc
  '';

  nixpkgs.config.virtualbox.enableExtensionPack = true;

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable the X11 windowing system.
   services.xserver.enable = true;
   services.xserver.layout = "us";
  #enable accelerated video playback
   services.xserver.vaapiDrivers = [ pkgs.vaapiIntel ];
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable the KDE Desktop Environment.
   services.xserver.displayManager.kdm.enable = true;
   services.xserver.desktopManager.kde4.enable = true;

   services.xserver.synaptics = {
     enable = true;
     palmDetect = true;
     twoFingerScroll = true;
     horizontalScroll = true;
     accelFactor = "0.082";
     maxSpeed = "15.0";
     minSpeed = "0.13";
     additionalOptions = ''
        Option "ClickPad" "true"
        Option "EmulateMidButtonTime" "0"
        #Option "EmulateTwoFingerMinZ" "0"
        #Option "EmulateTwoFingerMinW" "0"
        Option "SoftButtonAreas" "50% 0 3600 0 0 0 0 0"
        #Option "TapAndDragGesture" "0"
        Option "AreaBottomEdge" "3600"
     '';

   };


  services.avahi.enable = true;
  services.avahi.nssmdns = true; 

  # Define a user account. Don't forget to set a password with ‘passwd’.
   users.extraUsers.imagio = {
     name = "imagio";
     group = "users";
     extraGroups = [ "networkmanager" "wheel" "vboxusers" ];
     uid = 1000;
     createHome = true;
     home = "/home/imagio";
     shell = "/run/current-system/sw/bin/bash";
   };

}

{
  lib,
  config,
  ...
}: {
  options.nixconf.os.service.storage = {
    trim = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable fstrim for better SSD health";
    };

    hdapsd = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Hard-drive protection against drops for laptops";
    };

    gvfs = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Gnome Virtual FS for mounting remote resources (i.e. phones)";
    };

    udisk2 = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable udisk2 for auto mounting usb";
    };
  };

  config = {
    services = {
      # For ssd life discard unused blocks
      fstrim.enable = config.nixconf.os.service.storage.trim;

      # Hard disk protection if the laptop falls:
      hdapsd.enable = config.nixconf.os.service.storage.hdapsd;

      # Mount MTP devices (iPhone, Android, etc.)
      # Seamlessly access files and folders on remote resources.
      # Necessarry for file managers, mounts, trash, etc.
      gvfs.enable = config.nixconf.os.service.storage.gvfs;

      # In case gvfs doesn't work, enable udisk2 as well
      udisks2.enable = config.nixconf.os.service.storage.udisk2;
    };
  };
}

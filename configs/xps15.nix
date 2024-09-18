{
  nixconf = {
    system = {
      user = "mcst";

      hardware = {
        boot = {
          intelMicrocode = true;
          cpuFreqGovernor = "ondemand";
        };
        nvidia = {
          enable = true;
          isTuring = true;
        };
        peripherals = {
          bluetooth = true;
          logitech = true;
        };
        printer = {
          enable = true;
          printerDrivers = ["cups-dymo"];
          scanner = false;
        };
      };

      network = {
        hostname = "nixos";
        hosts = "";
        firewall = {
          enable = true;
          allowedTCPPorts = [];
          allowedTCPPortRanges = [];
          allowedUDPPorts = [];
          allowedUDPPortRanges = [];
        };
        wireguard = {
          enable = false;
          configs = [];
        };
        mtr = {
          enable = true;
          exportMtr = false;
        };
      };

      service = {
        power = {
          thermald = true;
          power-profiles-daemon = true;
        };
        dbus = {
          enable = true;
          tumbler = true;
        };
        storage = {
          trim = true;
          hdapsd = false;
          gvfs = true;
          udisk2 = true;
        };
        sound = {
          pipewire = true;
        };
        kanata = true;
      };

      desktop = {
        enable = true;
        de.gnome = true;
        wm = {
          enable = true;
          blueman = true;
          networkmanager = true;
          kanshi = true;
          login.greetd = {
            enable = false;
            command = "Hyprland";
          };
          tiling.hyprland = true;
          bar.waybar = true;
          launcher.rofi = true;
          notification.swaync = true;
        };
      };

      intune = true;
    };

    term = {
      starship = true;
      eza = true;
      bat = true;
      fzf = true;
      zoxide = true;
      direnv = true;
      scripts = true;

      systemd = {
        enable = true;
        sync-notes = true;
        sync-blog = true;
      };

      ai = true;
      alacritty = true;
      tmux = true;
      yazi = true;
    };

    browser = {
      brave = true;
      firefox = true;
      chrome = true;
    };

    media = {
      zathura = true;
      obsidian = true;
      zotero = true;
      calibre = true;
      gimp = true;
      spotify = true;
      vlc = true;
      qpwgraph = true;
      audacity = true;
      obs = true;
    };

    chat = {
      telegram = true;
      discord = true;
      slack = true;
      teams = false;
    };

    gaming = {
      steam = true;
      other = {
        minecraft = true;
        minecraft-server = false;
      };
    };

    dev = {
      git = {
        enable = true;
        gh = true;
        lazygit = true;
      };

      languages = {
        just = true;
        pre-commit = true;
        python = true;
        rust = true;
        go = true;
      };

      editor = {
        neovim = true;
        vscode = true;
        datagrip = false;
        helix = false;

        pycharm = {
          enable = false;
          professional = false;
        };
      };

      virtualisation = {
        qemu = true;
        virt-manager = true;
      };

      iac = {
        packer = true;
        terraform = true;
      };

      container = {
        docker = {
          enable = true;
          autoPrune = true;
        };

        podman = {
          enable = false;
          dockerCompat = false;
        };

        nerdctl = true;
        lazydocker = true;
        dive = true;
      };

      cicd = {
        argo = true;
        argocd = true;
      };

      k8s = {
        kubectl = true;
        k9s = true;
        minikube = true;
        kind = true;
        helm = true;
      };

      cloud = {
        aws = false;
        azure = false;
        cfssl = false;
        digital-ocean = false;
        gcloud = true;
        localstack = false;
      };
    };
  };
}

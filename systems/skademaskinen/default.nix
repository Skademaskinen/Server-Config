{pkgs, lib, config, modulesPath, ...}: let
    storage = "/mnt/raid";
    version = "23.11";
in {
    imports = [
        (modulesPath + "/installer/scan/not-detected.nix") 
        ./packages.nix
        ./modules
    ];

    # hardware
    boot.initrd.availableKernelModules = [ "xhci_pci" "ehci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
    boot.initrd.kernelModules = [ ];
    boot.kernelModules = [ ];
    boot.extraModulePackages = [ ];
    boot.swraid.enable = true;

    fileSystems = {
        "/" = { 
            device = "/dev/disk/by-label/ROOT";
            fsType = "ext4";
        };
        "/boot" = {
            device = "/dev/disk/by-label/BOOT";
            fsType = "vfat";
        };
        "${storage}" = {
            device = "/dev/disk/by-label/STORAGE";
            fsType = "ext4";
        };
    };
    swapDevices = [{ device="/dev/disk/by-uuid/3aac8229-8ab1-4c0d-a2c6-d27859553817"; }];

    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
    hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

    system.stateVersion = version;

    # security
    security.sudo.wheelNeedsPassword = false;

    nix.settings.allowed-users = ["root" "@wheel"];
    nix.settings.trusted-users = ["root" "@wheel"];

    networking.hostName = "Skademaskinen";

    # virtualisation specifics `nixos-rebuild build-vm --flake .#Skademaskinen`
    virtualisation.vmVariant = {
        virtualisation.memorySize = 8192;
        virtualisation.cores = 4;

        users.users.root.password = "1234";
        services.getty.autologinUser = "root";
        #virtualisation.forwardPorts = [
        #    { from = "host"; host.port = 2222; guest.port = 22; }
        #    { from = "host"; host.port = 8888; guest.port = 80; }
        #    { from = "host"; host.port = 4443; guest.port = 443; }
        #    { from = "host"; host.port = 8000; guest.port = 8000; }
        #    { from = "host"; host.port = 8001; guest.port = 8001; }
        #    { from = "host"; host.port = 8002; guest.port = 8002; }
        #    { from = "host"; host.port = 8003; guest.port = 8003; }
        #    { from = "host"; host.port = 8004; guest.port = 8004; }
        #];
        environment.etc."nextcloud-admin-password".text = "1234";
    };

    users.mutableUsers = false;

    # VPN CONFIG
    #services.openvpn.servers.VPN.config = "config ${storage}/VPN/windscribe.conf";

    networking.wireguard.interfaces = {
        wg0 = {
            ips = ["10.200.200.2/32"];
            listenPort = 51820;
            privateKeyFile = "${storage}/vpn/client.key";
            peers = [{
                publicKey = "fOPhWd+No02Doi2hvf3uXmAHYF+nyeOcmEBFWkzBRAk=";
                allowedIPs = ["10.200.200.0/24"];
                endpoint = "185.51.76.92:51820";
                persistentKeepalive = 25;
            }];
        };
    };

    services.mysql.enable = true;
    services.mysql.dataDir = "/mnt/raid/mysql";
    services.mysql.package = pkgs.mysql;

    # simple-nixos-mailserver
    #mailserver = {
    #    enable = true;
    #    fqdn = "mail.${config.skademaskinen.domain}";
    #    domains = [config.skademaskinen.domain];
    #    loginAccounts."mast3r@${config.skademaskinen.domain}" = {
    #        hashedPasswordFile = ../../files/passwd/mast3r.pw;
    #        aliases = ["admin@${config.skademaskinen.domain}" "postmaster@${config.skademaskinen.domain}"];
    #    };
    #    enablePop3Ssl = true;
    #
    #    certificateScheme = "acme-nginx";
    #};
    #security.acme = {
    #    acceptTerms = true;
    #    defaults.email = "security@${config.skademaskinen.domain}";
    #};

    # custom module settings
    skademaskinen = {
        storage = storage;
        putricide = {
            enable = true;
            config = "${storage}/bots/Putricide";
            args = [ "--disable-teams" ];
        };
        minecraft-servers = ["survival" "hub" "creative" "paradox"];

        rp-utils = {
            enable = true;
            root = "${storage}/bots/rp-utils";
        };

        mast3r.website = {
            enable = true;
            root = "${storage}/website/Backend";
            databasePath = "${storage}/website/db.db3";
            hostname = "localhost";
            port = 8000;
            keyfile = "${storage}/website/keyfile";
        };
        taoshi.website = {
            enable = true;
            port = 8004;
        };
        sketch-bot = {
            enable = true;
            root = "${config.users.users.taoshi.home}/SketchBot/SketchBot";
        };
        jupyter.port = 8002;
        nextcloud.port = 8003;

        matrix.enable = true;
        matrix.port = 8005;

        p8.enable = true;
        p8.port = 8006;
        p8.test.enable = true;
        p8.test.port = 8007;
        

    };
    globalEnvs.python.enable = true;
}

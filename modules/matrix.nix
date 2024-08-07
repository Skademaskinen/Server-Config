{pkgs, lib, config, ...}: {
    options = {
        skademaskinen.matrix.port = lib.mkOption {
            type = lib.types.int;
            default = 6167;
        };
        skademaskinen.matrix.enable = lib.mkOption {
            type = lib.types.bool;
            default = false;
        };
    };

    config.services.matrix-conduit = {
        enable = config.skademaskinen.matrix.enable;
        settings.global.port = config.skademaskinen.matrix.port;
        settings.global.server_name = "${config.skademaskinen.domain}";
        settings.global.database_backend = "rocksdb";
        settings.global.allow_registration = true;
        settings.global.trusted_servers = ["matrix.org"];
    };
}

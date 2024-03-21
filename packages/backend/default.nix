{pkgs}:let
    py = (pkgs.python3.withPackages (pyPkgs: with pyPkgs; [
        requests
        python-nmap
        bcrypt
    ]));

in pkgs.stdenv.mkDerivation {
    name = "backend";
    pname = "backend";
    
    src = pkgs.fetchFromGitHub {
        owner = "Skademaskinen";
        repo = "Backend";
        rev = "02fdf3a0c9d5c78c7d29eb37ec8917e62096a183";
        sha256 = "sha256-dbTSA5zGNThsb5zyHsCDUoSdmcaxa5Io0ZLIjzdFjeE=";
    };

    installPhase = ''
        mkdir -p $out/bin
        mkdir -p $out/share/Backend
        
        cp ./* $out/share/Backend -r
        echo "${py.interpreter} $out/share/Backend/skademaskinen/main.py \$@" > $out/bin/skademaskinen-backend
        chmod +x $out/bin/skademaskinen-backend

        cat > $out/bin/skademaskinen-backend-db << "EOF"
            if [[ "$1" == "" ]]; then
                db="/tmp/db.db3"
            else
                db="$1"
            fi
            for table in $(${pkgs.sqlite-interactive}/bin/sqlite3 $db '.tables'); do
                echo "Content of table: $table"
                ${pkgs.sqlite-interactive}/bin/sqlite3 $db "select * from $table" -box
            done
        EOF
        chmod +x $out/bin/skademaskinen-backend-db
    '';
        
}

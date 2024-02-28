{ config, lib, pkgs, modulesPath, ... }: {
    users.users.mast3r = {
        isNormalUser = true;
        description = "mast3r";
        extraGroups = [ "networkmanager" "wheel" "wireshark" "libvirtd" "tty" "dialout" ];
        shell = pkgs.zsh;
        packages = with pkgs; [
            firefox
            discord
            konsole
            jdk21
            git
            (python311.withPackages(pyPkgs: with pyPkgs; [
                ipython 
                bcrypt 
                matplotlib 
                sqlite 
                bash_kernel 
                python-nmap
            ]))
            sqlite-interactive
            font-awesome
            gtklock
            libreoffice
            swaybg
            git
            neofetch
            swayfx
            dunst
            eww-wayland
            bottles
            grim
            wl-clipboard
            slurp
            vscode
            libnotify
            direnv
            gtk3
            sshfs
            nixpkgs-fmt
            gparted
            spotify
            mangohud
            texliveFull
            haskell-language-server
            gimp
            wol
            zotero
            alsa-utils
            cmake
            bat
            sqlite
            screen
            maven
            ghc
            unzip
            pfetch
            tmux
            nmap
            wget
            lynx
            libsForQt5.plasma-workspace
            termshark
            texliveFull
            gradle
            gnumake
            gcc
            ((vim_configurable.override{}).customize{
                name = "vim";
                vimrcConfig.packages.myplugins = with pkgs.vimPlugins; {
                    start = [yuck-vim nerdtree];
                    opt = [];
                };
                vimrcConfig.customRC = ''
                    set tabstop=4
                    set shiftwidth=4 smarttab
                    set expandtab
                    set number
                    set nowrap
                    syntax on
                    set mouse=a
                    hi Normal guibg=NONE cterm=NONE
                    set sidescroll=1
                    set cursorline
                    hi CursorLine gui=underline cterm=underline
                    set termwinsize=10x0
                    cd %:p:h
                    autocmd BufReadPost *
                        \ if line("\"") > 0 && line("'\"") <= line ("$") |
                        \ exe "normal! g`\"" |
                        \ endif
                    let &t_SI = "\e[5 q"
                    let &t_EI = "\e[6 q"
                    set wildmenu
                    nnoremap <C-Left> :tabprevious<CR>
                    nnoremap <C-Right> :tabnext<CR>
                    nmap <cr> :$tabnew<CR>
                    nnoremap <C-Up> :NERDTree<CR>
                    set backspace=indent,eol,start
                '';
            })
        ];
    };
}

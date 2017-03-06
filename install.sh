#!/usr/bin/env bash

#   This setup file is based on spf13-vim's bootstrap.sh.
#   Thanks for spf13-vim.

app_name='cVim'
dot_cvim="$HOME/.cvim"
[ -z "$APP_PATH" ] && APP_PATH="$VIM/cVim"
[ -z "$REPO_URI" ] && REPO_URI='https://github.com/vashdawn/cVim.git'
[ -z "$REPO_BRANCH" ] && REPO_BRANCH='master'
debug_mode='0'
[ -z "$VIM_PLUG_PATH" ] && VIM_PLUG_PATH="$VIM/vimfiles/autoload"
[ -z "$VIM_PLUG_URL" ] && VIM_PLUG_URL='https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

########## Basic setup tools
msg() {
    printf '%b\n' "$1" >&2
}

success() {
    if [ "$ret" -eq '0' ];
    then
        msg "\33[32m[✔]\33[0m ${1}${2}"
    fi
}

error() {
    msg "\33[31m[✘]\33[0m ${1}${2}"
    exit 1
}

debug() {
    if [ "$debug_mode" -eq '1' ] && [ "$ret" -gt '1' ];
    then
        msg "An error occurred in function \"${FUNCNAME[$i+1]}\" on line ${BASH_LINENO[$i+1]}, we're sorry for that."
    fi
}

exists() {
    command -v "$1" >/dev/null 2>&1
}

program_exists() {
    local ret='0'
    exists "$1" || { local ret='1'; }

    # fail on non-zero return value
    if [ "$ret" -ne 0 ];
    then
        return 1
    fi

    return 0
}

program_must_exist() {

    # throw error on non-zero return value
    if ! program_exists "$1";
    then
        error "You must have '$1' installed to continue."
    fi
}

lnif() {
    if [ -e "$1" ];
    then
        ln -sf "$1" "$2"
    fi
    ret="$?"
    debug
}

########## Setup function
backup() {
    if [ -e "$1" ];
    then
        msg "Attempting to back up your original vim configuration."
        today=$(date +%Y%m%d_%s)
        mv -v "$1" "$1.$today"

        ret="$?"
        success "Your original vim configuration has been backed up."
        debug
    fi
}

sync_repo() {
    local repo_path="$1"
    local repo_uri="$2"
    local repo_branch="$3"
    local repo_name="$4"

    if [ ! -e "$repo_path" ];
    then
        msg "\033[1;34m==>\033[0m Trying to clone $repo_name"
        mkdir -p "$repo_path"
        git clone -b "$repo_branch" "$repo_uri" "$repo_path"
        ret="$?"
        success "Successfully cloned $repo_name."
    else
        msg "\033[1;34m==>\033[0m Trying to update $repo_name"
        cd "$repo_path" && git pull origin "$repo_branch"
        ret="$?"
        success "Successfully updated $repo_name"
    fi

    debug
}

create_symlinks() {
    local source_path="$1"
    local target_path="$2"

    lnif "$source_path/init.vim"            "$target_path/.vimrc"

    ret="$?"
    success "Setting up vim symlinks."

    debug
}

sync_vim_plug() {
    if [ ! -f "$VIM_PLUG_PATH/plug.vim" ];
    then
        curl -x 10.118.1.86:8123 -fLo "$1/plug.vim" --create-dirs "$2"
    fi

    debug
}

setup_vim_plug(){
    local system_shell="$SHELL"
    export SHELL='/bin/sh'

    vim \
        "+PlugInstall!" \
        "+PlugClean" \
        "+qall"

    export SHELL="$system_shell"

    success "Now updating/installing plugins using vim-plug"

    debug
}

generate_dot_cvim(){
    if [ ! -f "$dot_cvim" ];
    then
        touch "$dot_cvim"
        (
        cat <<DOTCVIM
" You can enable the existing layers in cVim and
" exclude the partial plugins in a certain layer.
" The command Layer and Exlcude are vaild in the function Layers().
function! Layers()

    " Default layers, recommended!
    Layer 'fzf'
    Layer 'unite'
    Layer 'better-defaults'

endfunction

" Put your private plugins here.
function! UserInit()

    " Space has been set as the default leader key,
    " if you want to change it, uncomment and set it here.
    " let g:spacevim_leader = "<\Space>"
    " let g:spacevim_localleader = ','

    " Install private plugins
    " Plug 'extr0py/oni'

endfunction

" Put your costom configurations here, e.g., change the colorscheme.
function! UserConfig()

    " If you enable airline layer and have installed the powerline fonts, set it here.
    " let g:airline_powerline_fonts=1
    " color desert

endfunction
DOTCVIM
) >"$dot_cvim"

    fi
}

########## Main()
program_must_exist "vim"
program_must_exist "git"

backup          "$HOME/.vimrc"

sync_repo       "$APP_PATH" \
                "$REPO_URI" \
                "$REPO_BRANCH" \
                "$app_name"

create_symlinks "$APP_PATH" \
                "$HOME"

sync_vim_plug   "$VIM_PLUG_PATH" \
                "$VIM_PLUG_URL"

generate_dot_cvim

setup_vim_plug

msg             "\nThanks for installing \033[1;31m$app_name\033[0m. Enjoy!"

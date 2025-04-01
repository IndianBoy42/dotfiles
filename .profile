# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi
source "$HOME/.cargo/env"

if [ -e /home/amedhi/.nix-profile/etc/profile.d/nix.sh ]; then . /home/amedhi/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer

[[ -s "/home/amedhi/.gvm/scripts/gvm" ]] && source "/home/amedhi/.gvm/scripts/gvm"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion


# >>> coursier install directory >>>
export PATH="$PATH:/home/amedhi/.local/share/coursier/bin"
# <<< coursier install directory <<<

# repeating keys go brrrr
xset r rate 220 25


export STM32CubeMX_PATH=/home/amedhi/STM32CubeMX
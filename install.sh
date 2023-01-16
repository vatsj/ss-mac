#!/bin/zsh
# (default mac shell is zsh)

# logs to running terminal
printf "\n setup script initiated \n"

# directories
PROJECT=$(pwd)
USRLIB=${HOME}/usrlib

# defining macros
source utils.sh

# installs Homebrew
# https://brew.sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# brew setup
echo '# Set PATH, MANPATH, etc., for Homebrew.' >> /Users/jstav/.zprofile
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> /Users/jstav/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"

# installs prereqs for dotfile script
# https://github.com/vatsj/dotfiles
brew install stow
brew install make

# runs aux scripts
printf "\n running aux scripts \n"

# all aux scripts run from `usrlib` directory
mkdir -p ${USRLIB}

# loops thru aux scripts
for script in ${PROJECT}/scripts/*.sh
do
  # cd to usrlib each time
  cd ${USRLIB}
  source ${script}
done

# language-specific scripts
cd ${PROJECT}/lang-scripts
chmod +x julia_init.jl
julia julia_init.jl

# record new path
printf "\n\n PATH: \n"
echo ${PATH}

# safer to record in .bashrc than to export?!
# export ${PATH}
echo export PATH=\"${PATH}\" >> ~/.bashrc

# return to project dir
cd ${PROJECT}
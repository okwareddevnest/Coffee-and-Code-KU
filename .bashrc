# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

[[ -e ~/.phpbrew/bashrc ]] && source ~/.phpbrew/bashrc

function appendto() {
    echo "$1" >> "$2"
}

function pushnew() {
    git remote add origin "$1"
    git push -u origin main
}


alias Init="git init"
alias status="git status"
alias branches="git branch"
alias merge="git merge"
alias Main="git branch -M main"
alias checkout="git checkout"
alias publish='branch=$(git rev-parse --abbrev-ref HEAD) && git add . && git commit -m "Auto-commit" && git push --set-upstream origin $branch'
alias commit="git add . && git commit -m"
alias push="git push origin"
alias pull="git pull"
. "$HOME/.cargo/env"


alias openfolder='xdg-open .'

#figlet banners
figlet -f standard -ct  "Dedan Okware" | lolcat
figlet -f digital -ct  "Fullstack Software Engineer || Blockchain" | lolcat


# Load Angular CLI autocompletion.
# source <(ng completion script)

# pnpm
export PNPM_HOME="/home/okwared/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
. "$HOME/.local/share/dfx/env"

alias pnpx='pnpm dlx'


convert_video() {
  ffmpeg -i "$1" -vf "scale='if(gt(a,1),ceil(iw/2)*2,-2)':'if(gt(a,1),-2,ceil(ih/2)*2)'" -c:v libx264 -preset slow -crf 22 -c:a aac -b:a 128k "$2"
}
export PATH="$PATH:/opt/mssql-tools/bin"
export PATH="$PATH:$HOME/.dotnet/tools"
export PATH="$PATH:$HOME/.dotnet/tools"
export DOTNET_ROOT=$HOME/.dotnet
export DOTNET_ROOT=/home/okwared/.dotnet







# Docker login/logout
alias docker-login='docker login'
alias docker-logout='docker logout'

# Docker list containers
alias docker-list-containers='docker ps'
alias docker-list-all-containers='docker ps -a'

# Docker images
alias docker-list-images='docker images'

# Docker stop/remove containers
alias docker-stop-all='docker stop $(docker ps -q)'
alias docker-remove-all-containers='docker rm $(docker ps -a -q)'

# Docker remove images
alias docker-remove-all-images='docker rmi $(docker images -q)'

# Docker cleanup
alias docker-remove-stopped-containers='docker container prune -f'
alias docker-remove-dangling-images='docker image prune -f'

# Docker pull/push images
alias docker-pull-image='docker pull'
alias docker-push-image='docker push'

# Docker tag image
alias docker-tag-image='docker tag'

# Docker image history
alias docker-image-history='docker history'

# Docker run with interactive terminal
alias docker-run-interactive='docker run -it'

# Docker build
alias docker-build-image='docker build'

# Docker logs
alias docker-container-logs='docker logs'





# Docker Compose aliases
alias docker-compose-start='docker-compose up'
alias docker-compose-start-detached='docker-compose up -d'
alias docker-compose-stop='docker-compose down'
alias docker-compose-rebuild='docker-compose build'
alias docker-compose-logs='docker-compose logs'
alias docker-compose-status='docker-compose ps'
alias docker-compose-restart='docker-compose restart'



export PATH="$PATH":"$HOME/.pub-cache/bin"
export PKG_CONFIG_PATH=/usr/lib/pkgconfig:/usr/share/pkgconfig
export PKG_CONFIG_PATH=/usr/lib/pkgconfig:/usr/share/pkgconfig


export ANDROID_HOME=$HOME/Android/Sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/tools/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools
export NDK_HOME=$ANDROID_HOME/ndk/27.0.12077973
export PATH=$PATH:$NDK_HOME
export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
export PATH=$JAVA_HOME/bin:$PATH
export PATH=$PATH:~/.local/bin

alias SuperEnv='bash ~/ml_env.sh'





[ -f "/home/okwared/.ghcup/env" ] && . "/home/okwared/.ghcup/env" # ghcup-env


export LD_LIBRARY_PATH="/usr/local/lib:$LD_LIBRARY_PATH"
export PKG_CONFIG_PATH="/usr/local/lib/pkgconfig:$PKG_CONFIG_PATH"

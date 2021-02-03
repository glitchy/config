# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
#ZSH_THEME="spaceship"
eval "$(/usr/local/bin/starship init zsh)"
# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )
# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"
# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"
# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"
# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"
# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13
# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"
# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"
# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"
# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"
# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"
# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
DISABLE_UNTRACKED_FILES_DIRTY="true"
# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"
# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder
# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git brew osx docker docker-compose)
source $ZSH/oh-my-zsh.sh
# User configuration
export ZSH_AUTOSUGGEST_USE_ASYNC="true"
# export MANPATH="/usr/local/man:$MANPATH"
# You may need to manually set your language environment
# export LANG=en_US.UTF-8
# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='nvim'
else
  export EDITOR='nvim'
fi
# Compilation flags
# export ARCHFLAGS="-arch x86_64"
# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
# ssh
export SSH_KEY_PATH="~/.ssh/id_ed25519"
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
alias vim="nvim -p"
alias vi="vim"
alias date="gdate"
alias zshconfig="vim ~/.zshrc"
alias ohmyzsh="vim ~/.oh-my-zsh"
alias ssh="TERM=xterm-256color ssh"
alias gt="sh ~/.scripts/generate_template.sh"
export GOPATH=~/Source/go
export GOROOT=/usr/local/opt/go/libexec
export PATH=/opt/local/bin:/opt/local/sbin:/usr/local/bin:/usr/local/opt/python/libexec/bin:/usr/local/sbin:$GOPATH/bin:$GOROOT/bin:$PATH:$HOME/.bin:$HOME/.cargo/bin:$HOME/Library/Python/3.7/bin
# This line fixes the stupid MacOS issues with building C code.
export LLVM_CONFIG_PATH=/usr/local/opt/llvm/bin/llvm-config
export PATH=/usr/local/opt/llvm/bin:$HOME/.emacs.d/bin:$PATH
export LDFLAGS="-L/usr/local/opt/llvm/lib"
export CPPFLAGS="-I/usr/local/opt/llvm/include"
# Function to automatically establish tmux session
# or attach to a ongoing tmux session automatically.
function ssh () {
    /usr/bin/ssh -t $@ "tmux attach || tmux new" || echo "The server you are connecting to doesn't appear to have 'tmux' installed. Try 'sssh' for connecting without automatic tmux connection.";
}
# Function to connect to vanilla SSH (no tmux).
function sssh () {
    /usr/bin/ssh $@;
}
function docker-cleanup () {
    echo 'Removing old containers...';
    docker rm -v $(docker ps -a -q -f status=exited);
    echo 'Removing old images...';
    docker rmi $(docker images -f "dangling=true" -q);
    echo 'Removing old volumes...';
    docker volume rm $(docker volume ls -qf dangling=true);
}
function update () {
    echo 'Updating OhMyZsh...';
    omz update;
    echo 'Updating Spaceship...';
    #pushd "$ZSH_CUSTOM/themes/spaceship-prompt"
    #    git reset --hard && git pull
    #popd
    echo 'Updating Homebrew Packages...';
    brew update && brew upgrade && brew upgrade --cask;
    echo 'Updating Neovim...';
    brew reinstall neovim;
    echo 'Updating Rust...';
    rustup update;
    echo 'Updating Rust Analyzer...';
    pushd ~/Source/rust-analyzer;
        git reset --hard && git pull
        gsed -i -e '/\[profile.release\]/ a\
lto = true\ncodegen-units = 1' Cargo.toml
        cargo update && cargo xtask install;
    popd;
    # Backup RUSTFLAGS to change for Clap installation.
    tmp=$RUSTFLAGS;
    export RUSTFLAGS="-C target-cpu=native -C link-arg=-undefined -C link-arg=dynamic_lookup";
    echo 'Updating Vim-Clap...';
    pushd ~/.config/nvim/pack/minpac/opt/vim-clap;
        git reset --hard && git pull
        make
    popd;
    export RUSTFLAGS=$tmp;
}
function cargo-kernel-mod-xbuild () {
    echo 'Running cargo-xbuild...';
    RUST_TARGET_PATH=$(pwd)/.. cargo xbuild --target x86_64-linux-kernel-module
}
#test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
fpath+=${ZDOTDIR:-~}/.zsh_functions
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
export ZSH_HIGHLIGHT_HIGHLIGHTERS_DIR=/usr/local/share/zsh-syntax-highlighting/highlighters
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
export PATH="/usr/local/opt/libressl/bin:$PATH"
export PATH="/usr/local/opt/llvm/bin:$PATH"
ssh-add
autoload -U +X bashcompinit && bashcompinit

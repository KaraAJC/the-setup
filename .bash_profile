export PATH=/usr/local/bin:$PATH

# Upgrading to mojave and trying to use mysql2, openssl needed to be reinstalled
# per: https://github.com/brianmario/mysql2/issues/795#issuecomment-337006164
export LIBRARY_PATH=$LIBRARY_PATH:/usr/local/opt/openssl/lib/

# Use RBENV for ruby
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi
  
# OG Prompt
# export PS1="\[\e[36m\]\u\[\e[m\] @ \[\e[35m\]\w\[\e[m\] [\[\e[33m\]\@\[\e[m\]]\[\e[32m\]\\$\[\e[m\] "

# Load git completions
git_completion_script=/usr/local/etc/bash_completion.d/git-completion.bash
test -s $git_completion_script && source $git_completion_script

# A more colorful prompt.
# \[\e[0m\] resets the color to default color
ColorReset='\[\e[0m\]'
#  \e[0;31m\ sets the color to red
ColorRed='\[\e[0;31m\]'
# \e[0;32m\ sets the color to green
ColorGreen='\[\e[0;32m\]'

# PS1 is the variable for the prompt you see everytime you hit enter.
git_prompt_script=/usr/local/etc/bash_completion.d/git-prompt.sh
if [ -s $git_prompt_script ]; then
  # if git-prompt is installed, use it (ie. to install it use:
  # `brew install git`)
  source $git_prompt_script
  export GIT_PS1_SHOWDIRTYSTATE=1
  # set the prompt to display current working directory in red along with git branch
  export PS1="\[\e[36m\]\u\[\e[m\] @ \[\e[35m\]\w\[\e[m\] [\[\e[33m\]\@\[\e[m\]]$ColorRed\$(__git_ps1)$ColorReset\[\e[32m\]\\$\[\e[m\]"

  # Another possibile prompt, with a color coded git-branch
  # export GIT_PS1_SHOWCOLORHINTS=1
  # export PROMPT_COMMAND='__git_ps1 "\n$ColorRed\W$ColorReset" " :> "'
  
else
  # otherwise omit git from the prompt
  export PS1="\[\e[36m\]\u\[\e[m\] @ \[\e[35m\]\w\[\e[m\] [\[\e[33m\]\@\[\e[m\]]\[\e[32m\]\\$\[\e[m\]"
fi

# Force grep to always use the color option and show line numbers
export GREP_OPTIONS='--color=always'

# Colors ls should use for folders, files, symlinks etc, see `man ls` and
# search for LSCOLORS
export LSCOLORS=ExGxFxdxCxDxDxaccxaeex
# Force ls to use colors (G) and use humanized file sizes (h)
alias ls='ls -Gh'

# Set sublime as the default editor
which -s subl && export EDITOR="subl --wait"

# Silences Warnings when running RSPEC
export RUBYOPT="-W0" rspec

## ALIASES ###
alias ls='ls -Gh'
alias gitlog="git log --all --decorate --oneline --graph"
alias dotfile="subl ~/.bash_profile"
alias savedotfile="source ~/.bash_profile"
alias pgrestart="rm -rf /usr/local/var/postgres && initdb /usr/local/var/postgres -E utf8 && pg_ctl -D /usr/local/var/postgres -l logfile start"
alias mysqlrestart="/usr/local/Cellar/mysql/5.7.21/bin/mysql.server restart"
alias whatamasi="say 'Today is $(date)'"
alias be="bundle exec"
alias desktop="cd ~/Desktop"
alias ghdir='mkdir .github && touch PR_TEMPLATE.md && touch ISSUE_TEMPLATE.md && git status && git add . && git commit -m"adds github system folder" && git push origin master'
alias reveal='defaults write com.apple.Finder AppleShowAllFiles TRUE;killall Finder'
alias weather="curl wttr.in"
alias rawr='fortune -s computers | cowsay -f moose | lolcat -i'
alias whh="git log -1 | cowsay -f dragon-and-cow | lolcat" #What Had Happened...
alias til="cd ~/Projects/kara_codes && be jekyll draft 'til CHANGEME -  $(date)' && subl ."
alias gitbranches="git for-each-ref --sort=-committerdate refs/heads/  | head"
alias prunebranches="git remote prune origin && git branch -v | grep '\[gone\]' | awk '{print $1}' | xargs git branch -D"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

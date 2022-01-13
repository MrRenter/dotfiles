# Load version control information
autoload -Uz vcs_info
precmd() { vcs_info }

#Formats version control info
#zstyle ':vcs_info:git*' actionformats "%s  %r/%S %b %m%u%c "

#Allows edition zsh prompt with functions
setopt PROMPT_SUBST

# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
unsetopt beep
bindkey -e
# End of lines configured by zsh-newuser-install
#
# The following lines were added by compinstall
zstyle :compinstall filename '/home/renter/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

#Im not sure. Something to help with colors. 
function colormap() {
  for i in {0..255}; do print -Pn "%K{$i}  %k%F{$i}${(l:3::0:)i}%f " ${${(M)$((i%6)):#3}:+$'\n'}; done
}

#Aliassssss
#I should check to see if exa exists and if not set it to ls --color
alias ls="exa --icons --group-directories-first"
alias ll="exa --icons --group-directories-first -l"
alias la="exa --icons --group-directories-first -la"

alias grep='grep --color'
alias quickHttpd='python3 -m http.server 8888'
alias getip="curl -s icanhazip.com"
alias sshtenjin="ssh tenjin 'zsh;'"

alias disks='echo "╓───── m o u n t . p o i n t s"; \
			 echo "╙────────────────────────────────────── ─ ─ "; \
			 lsblk -a; echo ""; \
			 echo "╓───── d i s k . u s a g e";\
			 echo "╙────────────────────────────────────── ─ ─ "; \
			 df -h;'

#Random terminal variables
LAST=$(dirname !$)

#Left and right prompt for zsh. %F{Blue}Some Text%f to set the color. %n is username. %m is hostname. %~ is dir
PROMPT="%F{cyan}%n%f on %F{130}%m%f at %F{blue}%~%f"$'\n'"%(?..%{$FX[reset]$FG[203]%})$FX[bold]➜$FX[no-bold]$FX[reset] "
RPROMPT='$(common_git_status)%* - $(common_battery_level)'

# Check to see if tmux is running if not reattach
if [ -z "$TMUX" ]
then
	    tmux attach -t TMUX || tmux new -s TMUX
fi

# Git status - This will generate the branch name for rprompt. It will color it depending on its git stage
common_git_status() {
    local message=""
    local message_color="%F{green}"

    # https://git-scm.com/docs/git-status#_short_format
    local staged=$(git status --porcelain 2>/dev/null | grep -e "^[MADRCU]")
    local unstaged=$(git status --porcelain 2>/dev/null | grep -e "^[MADRCU? ][MADRCU?]")

    if [[ -n ${staged} ]]; then
        message_color="%F{red}"
    elif [[ -n ${unstaged} ]]; then
        message_color="%F{yellow}"
    fi

    local branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
    if [[ -n ${branch} ]]; then
        message+="${message_color}${branch}%f"
	echo -n "${message} - "
    fi

}

#This will get battery percentage. >60 = green. >25 = yellow. 25 or lower = red
common_battery_level() {
	local battpercentage=""
    	local message=""
    	local isBattCharging=""
    if [ -f "/sys/class/power_supply/BAT1/capacity" ]; then    
	battpercentage+="$(cat /sys/class/power_supply/BAT1/capacity)"
    	isBattCharging+="$(cat /sys/class/power_supply/BAT1/status)"

    	if [ $battpercentage -gt 60 ]; then
       		message+='%F{green}'
    	elif [ $battpercentage -gt 25 ]; then
        	message+='%F{yellow}'
    	else
		message+='%F{red}'
    	fi

    	message+="${battpercentage}"
    	message+="%% "
    fi
    if [[ $isBattCharging == "Discharging" ]] then
    	message+='🔋'
    else
	message+='🔌'
    fi
    echo -n "${message}%f"
}

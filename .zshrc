# ======================================================================
# Powerlevel10k Instant Prompt (Должно быть в самом верху)
# ======================================================================
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ======================================================================
# Базовые переменные окружения и пути
# ======================================================================
export PATH="$HOME/bin:/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:/usr/games:$HOME/.local/bin:$HOME/.cargo/bin:$HOME/go/bin:$PATH"
export EDITOR="nvim"
export PAGER="most"
export BROWSER="w3m"
export PF_INFO="ascii title os uptime shell pkgs wm memory palette"

# ======================================================================
# Настройки Oh My Zsh и плагины
# ======================================================================
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"

# Кейс-инсенситивное автодополнение (a = A)
CASE_SENSITIVE="false"

plugins=(git zsh-autosuggestions zsh-syntax-highlighting fzf)
source $ZSH/oh-my-zsh.sh

# ======================================================================
# Пользовательские алиасы (перенесены из .bashrc)
# ======================================================================
# Файловые операции и навигация
alias ls='ls --color=auto'
alias dir='dir --color=auto'
alias vdir='vdir --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias nano='nvim'
alias micro='nvim'
alias sudo='sudo '
alias cd..='cd ..'
alias ...='cd ..'
alias ....='cd ../..'
alias gm='cd /media'
alias gc='cd ~/.config'
alias ranger='TERM=xterm-256color ranger'

# Утилиты
alias top10='cat ~/.zsh_history | uniq -c | sort -nr | head -n 10'
alias ports='lsof -i -n -P'
alias mkdir='mkdir -p'

# Пакетный менеджер apt
alias debin='sudo apt install --no-install-recommends'
alias debrm='sudo apt autoremove --purge'
alias debup='sudo apt update && sudo apt full-upgrade'
alias debsh='apt search'
alias debvs='apt-cache policy'

# Питание системы
alias :q='exit'
alias oust='echo "bye $USER..."; sleep 2s && systemctl poweroff'
alias comeback='echo "be back right now..."; sleep 2s && systemctl reboot'

# Управление конфигом Zsh
alias zshcfg='$EDITOR ~/.zshrc'
alias zshrld='source ~/.zshrc'

# Разное
alias nospace='rename "y/ /_/ " *'
alias clr='clear'
alias invertcolors='xcalib -i -a'
alias starwars="telnet towel.blinkenlights.nl"
alias getweb='wget -r -np --user-agent=Firefox -l5 -k -E '
alias genpass='echo `< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c12`'
alias bm='bashmount'
alias ff='fastfetch'

eval "$(zoxide init zsh)"
# ======================================================================
# Функции (перенесены из .bashrc)
# ======================================================================
# Поиск по имени в текущей директории
function ff() { find . -type f -iname '*'$*'*' -ls | $PAGER ; }

# Создание резервной копии файла с датой
function bak() { cp $1 $1_`date +%Y-%m-%d_%H:%M:%S`.bak ; }

# Отчет по размеру директорий
function space() { du -skh * | sort -hr ; }

# Универсальная распаковка архивов
function extract() {
     if [ -f $1 ] ; then
         case $1 in
             *.tar.bz2)   tar xvjf $1     ;;
             *.tar.gz)    tar xvzf $1     ;;
             *.bz2)       bunzip2 $1      ;;
             *.rar)       unrar x $1      ;;
             *.gz)        gunzip $1       ;;
             *.tar)       tar xvf $1      ;;
             *.tbz2)      tar xvjf $1     ;;
             *.tgz)       tar xvzf $1     ;;
             *.zip)       unzip $1        ;;
             *.Z)         uncompress $1   ;;
             *.7z)        7z x $1         ;;
             *.xz)        unxz $1         ;;
             *)           echo "'$1' cannot be extracted via >extract<" ;;
         esac
     else
         echo "'$1' is not a valid file"
     fi
}

# Быстрое создание архивов
mktar() { tar cvf  "${1%%/}.tar"     "${1%%/}/"; }
mktgz() { tar cvzf "${1%%/}.tar.gz"  "${1%%/}/"; }
mktbz() { tar cvjf "${1%%/}.tar.bz2" "${1%%/}/"; }
mktxz() { tar cvJf "${1%%/}.ta.xz" "${1%%/}/"; }

# Превью консольных цветов
function clipv() {
  for i in {0..255} ; do
    printf "\x1b[48;5;%sm%3d\e[0m " "$i" "$i"
    if (( i == 15 )) || (( i > 15 )) && (( (i-15) % 6 == 0 )); then
        printf "\n";
    fi
  done
}

# ======================================================================
# Финальные загрузки
# ======================================================================
# Загрузка специфичных для GPU скриптов (если есть)
[ -f ~/.gpu-prime ] && source ~/.gpu-prime

# Конфигурация темы Powerlevel10k
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
export RANGER_LOAD_DEFAULT_RC=FALSE
export TERM=xterm-256color

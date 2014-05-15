alias ls="ls --color=auto -CF"
alias ll="ls -lah"
alias df="df -Tha --total"
alias du="du -ach | sort -h"
alias free="free -mt"
alias ps="ps awwfux"
alias mkdir="mkdir -p"
alias wget="wget -c"
alias most="history | awk '{CMD[$2]++;count++;}END { for (a in CMD)print CMD[a] " " CMD[a]/count*100 "% " a;}' | grep -v "./" | column -c3 -s " " -t | sort -nr | nl |  head -n10"

echo -e " `hostname`" | toilet -f ivrit -F metal
echo -e "
\e[0;37m+++++++++++++++++: \e[4;34mSystem Data\e[0;37m :+++++++++++++++++++
+   \e[1;30mHostname \e[0;32m= \e[1;35m`hostname`
\e[0;37m+   \e[1;30mAddress \e[0;32m= \e[1;35m`curl icanhazip.com`
\e[0;37m+   \e[1;30mKernel \e[0;32m= \e[1;35m`uname -r`
\e[0;37m+   \e[1;30mUptime \e[0;32m= \e[1;35m`uptime | sed 's/.*up ([^,]*), .*/1/'`
\e[0;37m++++++++++++++++++: \e[4;34mUser Data\e[0;37m :++++++++++++++++++++
+   \e[1;30mUsername \e[0;32m= \e[1;35m`whoami`
\e[0;37m+   \e[1;30mLast Login \e[0;32m= \e[1;35m`last $USER | head -n 1 | awk '/still logged in/ {print $3,$4,$5,$6}'`
\e[0;37m+++++++++++++++++++++++++++++++++++++++++++++++++++\e[0m
"

function extract {
 if [ -z "$1" ]; then
    # display usage if no parameters given
    echo "Usage: extract <path/file_name>.<zip|rar|bz2|gz|tar|tbz2|tgz|Z|7z|xz|ex|tar.bz2|tar.gz|tar.xz>"
 else
    if [ -f $1 ] ; then
        # NAME=${1%.*}
        # mkdir $NAME && cd $NAME
        case $1 in
          *.tar.bz2)   tar xvjf ../$1    ;;
          *.tar.gz)    tar xvzf ../$1    ;;
          *.tar.xz)    tar xvJf ../$1    ;;
          *.lzma)      unlzma ../$1      ;;
          *.bz2)       bunzip2 ../$1     ;;
          *.rar)       unrar x -ad ../$1 ;;
          *.gz)        gunzip ../$1      ;;
          *.tar)       tar xvf ../$1     ;;
          *.tbz2)      tar xvjf ../$1    ;;
          *.tgz)       tar xvzf ../$1    ;;
          *.zip)       unzip ../$1       ;;
          *.Z)         uncompress ../$1  ;;
          *.7z)        7z x ../$1        ;;
          *.xz)        unxz ../$1        ;;
          *.exe)       cabextract ../$1  ;;
          *)           echo "extract: '$1' - unknown archive method" ;;
        esac
    else
        echo "$1 - file does not exist"
    fi
fi
}

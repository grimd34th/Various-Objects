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
alias ls='ls --color=auto'

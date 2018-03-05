# jsMonitor
Monitors a running js process and notifies incase of frequent restarts.

## Install utility via curl
    mkdir -p ~/bin/shellscript && curl -s https://raw.githubusercontent.com/MuzammilM/jsMonitor/master/jsMonitor.sh -o ~/bin/shellscript/jsMonitor.sh 

## Install utility as a cronjob
    mv crontab crontab.backup || mkdir -p ~/logs/cronLogs/ && crontab -l > crontab && echo "* * * * * bash ~/bin/shellscript/jsMonitor.sh > ~/logs/cronLogs/jsMonitor.log" >> crontab && crontab crontab
    
## Install utility via curl and setup as a cronjob
    
    mkdir -p ~/bin/shellscript && curl -s https://raw.githubusercontent.com/MuzammilM/jsMonitor/master/jsMonitor.sh -o ~/bin/shellscript/jsMonitor.sh && mv crontab crontab.backup || mkdir -p ~/logs/cronLogs/ && crontab -l > crontab && echo "* * * * * bash ~/bin/shellscript/jsMonitor.sh > ~/logs/cronLogs/jsMonitor.log" >> crontab && crontab crontab

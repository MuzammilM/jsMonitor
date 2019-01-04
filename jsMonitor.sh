echo $USER
echo '**************************'
echo "JsMonitor Version 6 -- 20190104"
echo "Authored by Muzammil"
echo '**************************'
echo `date`
COLOR='\033[0;31m'
reset=`tput sgr0`

if [ ! -f "/home/"$USER"/config/shellscript/jsMonitor.properties" ]; then
        echo -e "${COLOR}Property file not found. Please create one called jsMonitor.properties within ~/config/shellscript ${reset}"
        echo -e "${COLOR}Format${reset}"
        `curl https://raw.githubusercontent.com/MuzammilM/jsMonitor/master/jsMonitor.properties`
        exit
fi

if [ ! -d "/home/"$USER"/logs/shellLogs/" ]; then
        mkdir -p ~/logs/shellLogs/
        exit
fi
if ! [ -x "$(command -v mail)" ]; then
  echo "Installing additional mailer package"
  curl -s https://raw.githubusercontent.com/MuzammilM/scripts/master/mail/mailSetup.sh | sudo bash -s notest
fi

function sendlog() {
                name=$1
                logFile=$2
                tail -n 2000 $logFile > $newlogFile
                echo "PFA with details of exception . Page Breakage." | mail -r USER -a $newlogFile -s "Logs For"$name" in "$ENV -c email1@xyz.com email2@xyz.com
                bash ~/bin/shellscript/slackBot.sh webgroup $name "Restarted in "$HOSTNAME"-"$ENV
}
PATH=$PATH:/usr/local/bin/
/usr/local/bin/forever columns rm script
/usr/local/bin/forever columns add script
/usr/local/bin/forever columns add dir
host=`hostname`
while IFS='' read -r webProp || [[ -n "$webProp" ]]; do
eval $webProp
echo '**************************'
echo "dir="$dir
echo "nodeScript="$nodeScript
cmd=`/usr/local/bin/forever list --plain | grep "$nodeScript" | awk '{print $3}'`
logFile=`/usr/local/bin/forever list --plain | grep "$nodeScript" | awk '{print $7}'`
status=`/usr/local/bin/forever list --plain | grep "$nodeScript" | awk '{print $8}'`
newlogFile="/home/"$USER"/logs/foreverLogs/"$cmd".log"
echo "cmd="$cmd
echo "status="$status
echo "logFile="$logFile
z=`echo $status | tr -d '[:cntrl:]'`
z1=`echo $logFile | tr -d '[:cntrl:]'`
d=`echo $status | cut -d \: -f 1`
h=`echo $status | cut -d \: -f 2`
m=`echo $status | cut -d \: -f 3`
s=`echo $status | cut -d \: -f 4`
cnt=`/usr/local/bin/forever list --plain | grep "$nodeScript" | grep -v grep | wc -l`
if [ $cnt = 0 ]
then
cd $dir
/usr/local/bin/forever start $nodeScript
echo 'process---------->'$nodeScript'------->started @'`date` >> ~/logs/shellLogs/jsLog.log
bash ~/bin/shellscript/slackBot.sh webgroup $name "Restarted in "$HOSTNAME"-"$ENV
echo $name
elif [ $cnt != 0 ]
then
        stoppedValue="STOPPED"
        if [ "$status" == "$stoppedValue" ]
                then
                sendlog $name $logFile
                /usr/local/bin/forever restart $cmd
        elif [[ (  "$d" -eq 00 && "$h" -eq 00 && "$m" -lt 1 ) ]]
                then
                echo "Restarted"
                sendlog $name $logFile
        else
        echo ':)'
fi
else
echo "Unhandled"
fi
done < ~/config/shellscript/jsMonitor.properties

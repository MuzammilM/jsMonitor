echo '**************************'
#echo "JsMonitor Version 5 -- 20170310"
#echo "Authored by Muzammil"
# Last updated on 05/03/2017
echo '**************************'
echo `date`
PATH=$PATH:/usr/local/bin/


if [ ! -f "/home/"$USER"/config/shellscript/jsMonitor.properties" ]; then
        echo -e "${COLOR}Property file not found. Please create one called jsMonitor.properties within ~/config/shellscript ${reset}"
        exit
fi

if [ ! -d "/home/"$USER"/logs/shellLogs/" ]; then
        mkdir -p ~/logs/shellLogs/
        exit
fi

config/shellscript/jsMonitor.properties
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
newlogFile="/home/mpuser/logs/foreverLogs/"$cmd".log"
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
# java -jar /home/$USER/bin/jars/sms.jar "1234567890,0987654321" $name "Restarted in "$HOSTNAME"-"$ENV
echo $name
elif [ $cnt != 0 ]
then
        stoppedValue="STOPPED"
        if [ "$status" == "$stoppedValue" ]
                then
                tail -n 100 $logFile > $newlogFile
                java -jar bin/jars/emailAttachments.jar config/emailProps.properties "testuser@gmail.com" "testuser2@gmail.com" "foreverLog For"$name "PFA with details of exception . Page Breakage" $newlogFile
                java -jar /home/$USER/bin/jars/sms.jar "1234567890,0987654321" $name "Restarted in "$HOSTNAME"-"$ENV
                /usr/local/bin/forever restart $cmd
        elif [[ (  "$d" -eq 00 && "$h" -eq 00 && "$m" -lt 1 ) ]]
                then
                echo "Restarted"
                echo 'Restarted' >> /home/$USER/logs/cronLogs/jsMonitorV3.log
                tail -n 100 $logFile > $newlogFile
                java -jar bin/jars/emailAttachments.jar config/emailProps.properties "testuser@gmail.com" "testuser2@gmail.com" "foreverLog For "$name "PFA with details of exception . Page Breakage" $newlogFile
                java -jar /home/$USER/bin/jars/sms.jar "1234567890,0987654321" $name "Restarted in "$HOSTNAME"-"$ENV
        else
        echo ':)'
fi
else
echo "Unhandled"
fi
done < ~/config/shellscript/jsMonitor.properties

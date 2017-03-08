#!/bin/bash
usage()
{
    echo "$0 {-h} {-d dir} {-R dir}"
    echo " -h: help"
    echo " -f: add files under new dir"
    echo " -F: add all files under dir recursivly"
    echo " -D: delete all files under dir recursivly"
    echo " -s: delete all files that contain the strings"
    echo " defalut: clear the old cscope_files,add all files under dir recursivly"
    exit 0

}

#config by user
sample=1
if [ $sample == 1 ];then
    wifi_mode=wep
    essid_name=TP-LINK_DD92
    psk=
else
    wifi_mode=wap
    essid_name=WhaleyVR
    psk=Lewo141118
fi


#Gloabl Var
PWD=`pwd`
CONFIG_FILE=/etc/wpa_supplicant/wpa_supplicant.conf
echo "config file="$CONFIG_FILE
echo "essid_name="$essid_name
echo "psk="$psk
echo "wifi_mode="$wifi_mode

while getopts hP: opt
do
    case "$opt" in
        h)
            usage;
            ;;
        P)
            PASSWD="$OPTARG"
            shift $((OPTIND - 1))
	    echo "PASSWD="$PASSWD
            ;;

        ?)
            exit 0;
            ;;
    esac
done


#Main
if [ ! -f $CONFIG_FILE ]; then
    echo "config file doesn't exsist"
    exit -1
fi

#sudo ip addr flush dev wlan0
#sudo ip route flush dev wlan0
##close
#sudo ip link set dev wlan0 down
#
#open the interface
sudo ip link set wlan0 up
sleep 1
sudo iw dev wlan0 scan | less
sleep 2
if [ "$wifi_mode" == "wep" ] && [ -z "$psk" ]; then
echo "444444444444444"
    sudo iw dev wlan0 connect $essid_name
fi
if [ "$wifi_mode" == "wep" ] && [ -n "$psk" ]; then
echo "3222222222222222222222"
    sudo iw dev wlan0 connect $essid_name key 0:$psk
fi
if [ "$wifi_mode" == "wap" ] && [ -n "$psk" ]; then
    #wpa_passphrase $essid_name $psk >> $CONFIG_FILE
#cat > $CONFIG_FILE <<EOF
#network={
#    ssid="$essid_name"
#    psk="$psk"
#    key_mgmt=WPA-PSK
#    priority=1
#}
#EOF
    sleep 1
    sudo wpa_supplicant -B -i wlan0 -c $CONFIG_FILE
    sudo dhcpcd wlan0
#sudo dhclient wlan0
#sudo ip addr add 172.29.91.56/24 broadcast 172.29.91.255 dev wlan0
#sudo ip route add default via 172.29.91.254
    echo "1111111111111111111111111"
fi



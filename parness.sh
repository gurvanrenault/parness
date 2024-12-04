#!/bin/bash

GREEN=$'\e[0;32m'
YELLOW=$'\e[0;33m'
RED=$'\e[0;31m'
NC=$'\e[0m'

isCommandFound=false
isParameterCheckFound=false
isParameterScanFound=false
list_commands="check scan"
list_parameters_check="dns all proxy daemon memory diskspace sudoers"
list_parameters_scan=" all rootkit antivirus eviltwin"
echo "${BLANK}"
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Sanitize input from user 
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Check parameters inputs  
if  [ $# -lt 2 ]; then
 cat  README.md
else
    for command in $list_commands; do 
        if [ "$command" = "$1" ]; then 
           isCommandFound=true 
           break 
      fi 
    done

    if [ "$1" = "check" ]; then
        for  parameter in $list_parameters_check; do 
            if [ "$parameter" = "$2" ]; then 
                isParameterCheckFound=true
                break 
            fi 
        done

    elif  [ "$1" = "scan" ]; then
        for  parameter in $list_parameters_scan; do 
            if [ "$parameter" = "$2" ]; then 
                isParameterScanFound=true
                break 
            fi 
        done

    fi
fi
# Limit cases 
if [ "$2" = "$3" ] && [ "$2" = "all" ]; then
   isParameterScanFound=false 
fi
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
if [ "$isCommandFound" = true ] && [ "$(id -u)" -eq 0 ] && ([ "$isParameterCheckFound" = true ] || [ "$isParameterScanFound" = true ]) ; then

        echo "___________ _______  ____   ____   ______ ______"
        echo "\____ \__  \\_  __ \/    \_/ __ \ /  ___//  ___/"
        echo "|  |_> > __ \|  | \/   |  \  ___/ \___ \ \___ \ "
        echo "|   __(____  /__|  |___|  /\___  >____  >____  >"
        echo "|__|       \/           \/     \/     \/     \/ "           
        # Add your name here if you participate to this project  
        echo " By : Gurvan Renault"

        echo " \n \n"
        os=`cat /etc/os-release | grep 'NAME\|VERSION' | grep -v 'VERSION_ID' | grep -v 'PRETTY_NAME' | grep NAME`
        echo "Operating System : $os";
        if [ "$1" = "check" ] && ([ "$2" = "diskspace" ] ||  [ "$2" = "all" ]); then
                echo  "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
                echo  "~~~~~~~~~~~~~~~~~~ Disk space  ~~~~~~~~~~~~~~~~~~~~~~"
                echo  "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
                df -h
        fi
        if [ "$1" = "check" ] && ([ "$2" = "memory" ] ||  [ "$2" = "all" ]); then
                echo  "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
                echo  "~~~~~~~~~~~~~~~~~ Free memory  ~~~~~~~~~~~~~~~~~~~~~~"
                echo  "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
                free -h 
        fi
        if [ "$1" = "check" ] && ([ "$2" = "dns" ] || [ "$2" = "all" ]); then
                echo  "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
                echo  "~~~~~~~~~~~~~~~ DNS Configuration ~~~~~~~~~~~~~~~~~~~"
                echo  "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
                DNSVALUE=$(sudo grep -Eo '([0-9]+\.)+[0-9]+' /etc/resolv.conf)
                echo "DNS value found :  $DNSVALUE in /etc/resolv.conf"
                echo "Searching DNS value in the whitelist"
                if grep -q $DNSVALUE whitelistDNS ; then
                echo "${GREEN} DNS value found in whitelist ${NC}"
                else
                echo -e "${RED} DNS value seems altered and/or malicious ${NC}"
                fi
        fi 
        if [ "$1" = "check" ] && ([ "$2" = "proxy" ] || [ "$2" = "all" ]); then
                echo  "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
                echo  "~~~~~~~~~~~~~~ Proxy configuration ~~~~~~~~~~~~~~~~~~"
                echo  "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
                if [ ! -z $http_proxy ]; then
                echo "Current HTTP proxy is $http_proxy ..."
                else
                echo "HTTP proxy is not configured"
                fi
                if [ ! -z $https_proxy ]; then
                echo "Current HTTPS proxy is $https_proxy ..."
                else
                echo "HTTPS proxy is not configured "
                fi
        fi
        if [ "$1" = "check" ]  && ([ "$2" = "sudoers" ] ||  [ "$2" = "all" ]); then
                echo  "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
                echo  "~~~~~~~~~~~~~~~~~ List Sudoers  ~~~~~~~~~~~~~~~~~~~~~"
                echo  "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
                getent group sudo | cut -d: -f4
        fi
        if [ "$1" = "check" ] && ([ "$2" = "daemon" ] ||  [ "$2" = "all" ]); then
                echo  "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
                echo  "~~~~~~~~~~~~~~~~~ Daemon list  ~~~~~~~~~~~~~~~~~~~~~~"
                echo  "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
                systemctl | grep daemon
        fi

        #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~     

        if [ "$1" = "scan" ] && ([ "$2" = "eviltwin" ] ||  [ "$2" = "all" ]); then
                echo  "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
                echo  "~~~~~~~~~~~~~~~ Evil Twin Detection ~~~~~~~~~~~~~~~~~"
                echo  "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
                
                mac_adresses_nearby="$(sudo iwlist wlp0s20f3 scanning | grep -Eo '(([0-9]|[A-Z]){2}+\:){5}([0-9]|[A-Z]){2}')"
                freq_net_nearby="$(sudo iwlist wlp0s20f3 scanning | grep "Frequency")"
                essid_net_nearby="$(sudo iwlist wlp0s20f3 scanning | grep "ESSID" | grep -o '".*"')"
                essid_net_nearby="$(echo $essid_net_nearby | tr -d '"')"
                


                essid_net_nearby_arr=($essid_net_nearby)
                freq_net_nearby_arr=($freq_net_nearby)
                mac_adresses_nearby_arr=($mac_adresses_nearby)

                
                index_net=0
                essid_net_evil_twin=""
                for mac_adress in $mac_adresses_nearby; do
                     essid=${essid_net_nearby_arr[$index_net]}
                     freq_net=${freq_net_nearby_arr[$index_net]}
                     count_occ_essid=$(echo "$essid_net_nearby" | grep -o "$essid" | wc -l)
                     count_occ_mac=$(echo "$mac_adresses_nearby" | grep -o "$mac_adress" | wc -l)

                     echo " Network found ESSID:  $essid MAC:  $mac_adress ..."
                     
                     if [ $count_occ_essid -ge 2 ] && [ $count_occ_essid != $count_occ_mac ]; then
                        echo "${YELLOW} Potential evil twin attack is detected ESSID : $essid MAC:$mac_adress"
                        echo "Please investigate using iwlist <interface> scanning ${NC}"
                     fi 
                     index_net=$index_net+1
                done
                






        fi

        if [ "$1" = "scan" ] && ([ "$2" = "rootkit" ] ||  [ "$2" = "all" ]); then
                echo  "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
                echo  "~~~~~~~~~~~~~~~ Rootkit Detection ~~~~~~~~~~~~~~~~~~~"
                echo  "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
                echo  "Credits : https://www.chkrootkit.org/"
                chkrootkit -q 
        fi

        if [ "$1" = "scan" ] && ([ "$2" = "antivirus" ] ||  [ "$2" = "all" ]) && ([ "$3" = "binaries" ] || [ "$3" = "all" ])   ; then
                echo  "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
                echo  "~~~~~~~~~~~~~ Binairies virus detection ~~~~~~~~~~~~~"
                echo  "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
                sudo clamscan -r /bin/*
        fi
        if [ "$1" = "scan" ] && ([ "$2" = "antivirus" ] ||  [ "$2" = "all" ]) && ([ "$3" = "home" ] || [ "$3" = "all" ]); then
                echo  "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
                echo  "~~~~~~~~~~~~ Home files virus detection ~~~~~~~~~~~~"
                echo  "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
                sudo clamscan -r ~/
        
        
        fi
        if [ $# -eq 3 ] && [ "$1" = "scan" ] && [ "$2" = "antivirus" ] && [  "$3" != "all" ]; then
                echo  "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
                echo  "Scan target : $3 "
                echo  "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
                sudo clamscan -r $3
        fi
        #TODO : Vérifier mes droits dans un fichiers / dossier
else
    cat README.md
fi

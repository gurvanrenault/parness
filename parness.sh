#!/bin/sh

GREEN='\033[0;32m'
RED='\033[0;31m'
BLANK='\033[0;37m'

isCommandFound=false
isParameterCheckFound=false
isParameterScanFound=false
list_commands="check scan"
list_parameters_check="dns all proxy daemon memory diskspace sudoers"
list_parameters_scan=" all rootkit antivirus"
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
                echo "${GREEN}DNS value found in whitelist ${BLANK}"
                else
                echo -e "${RED}DNS value seems altered and/or malicious ${BLANK}"
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

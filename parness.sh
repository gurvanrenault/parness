#!/bin/sh
GREEN='\033[0;32m'
RED='\033[0;31m'
BLANK='\033[0;37m'

isCommandFound=false
isParameterCheckFound=false

list_commands="check"
list_parameters_check="dns all proxy deamon"

echo "${BLANK}"
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Sanitize input from user 
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
if  [ $# -lt 2 ]; then
 echo "AAAAAAA"; 
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
       
        echo "isParameterCheckFound : $isParameterCheckFound"
        if [ "$isParameterCheckFound" = "false" ];then
           
            cat README.md 

        fi
    fi
fi
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
if [ isCommandFound ]; then
        if [ "$1" = "check" ] && ([ "$2" = "dns" ] || [ "$2" = "all" ]); then
                echo  "Check DNS in whitelist ... "
                DNSVALUE=$(sudo grep -Eo '([0-9]+\.)+[0-9]+' /etc/resolv.conf)
                echo "DNS value found :  $DNSVALUE"
                if grep -q $DNSVALUE whitelistDNS ; then
                echo "${GREEN}DNS value found in whitelist ${BLANK}"
                else
                echo -e "${RED}DNS value seems altered and/or malicious ${BLANK}"
                fi
        fi 
        if [ "$1" = "check" ] && ([ "$2" = "proxy" ] || [ "$2" = "all" ]); then
                if [ ! -z $http_proxy ]; then
                echo "Current HTTP proxy is $http_proxy ..."
                else
                echo "HTTP proxy is not configured"
                fi
                if [ ! -z $https_proxy ]; then
                echo "Current HTTPS proxy is $https_proxy ..."
                else
                echo "HTTPS proxy is not configured ..."
                fi
        fi
        if [ "$1" = "check" ] && ([ "$2" = "deamon" ] ||  [ "$2" = "all" ]); then
                echo  "Listing all deamons ... "
                systemctl | grep daemon
        fi
fi

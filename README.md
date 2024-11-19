*Parness* is a simple bash script to check the configuration of your Linux system.

# Requirements 

In order to use Parness, you must have root privileges

# Commands 

* Check all the configuration

``./parness.sh check all ``

* Check memory state

``./parness.sh check memory ``

* Check disk usage

``./parness.sh check diskspace ``

* Check DNS configuration

``./parness.sh check dns ``

The file *whitelistDNS* contains all authorized DNS IP adresses.
The script check if the current DNS adress is in this whitelist 

* Check proxy configuration

`` ./parness.sh check proxy ``

* Check deamon processes

``./parness.sh check deamon ``


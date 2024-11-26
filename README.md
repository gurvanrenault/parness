*Parness* is a simple bash script to check the configuration of your Linux system.

# Requirements 

In order to use Parness, you must have root privileges

# Commands 

* Check all the configuration

``sh parness check all ``

* Check memory state

``sh parness check memory ``

* Check disk usage

``sh parness check diskspace ``

* Check DNS configuration

``sh parness check dns ``

The file *whitelistDNS* contains all authorized DNS IP adresses.
The script check if the current DNS adress is in this whitelist 

* Check proxy configuration

`` sh parness check proxy ``

* Check the list of sudoers

`` sh parness check sudoers``

* Check deamon processes

``sh parness check daemon ``


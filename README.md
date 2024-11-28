*Parness* is a simple bash script to check the configuration and the health of your Linux system.


# RUN *Parness* 
`sudo ./parness `*`[options]`*``

# REQUIREMENTS 

* In order to use Parness, you must have root privileges

* Chkrootkit : 
``sudo apt get install chkrootkit ``

* ClamAV : 
``sudo apt get install clamav ``

# COMMANDS 

## Check the configuration
   
* ``check all `` \
  \
  Check all the configurations.

* `` check memory `` \
  \
  Check the memory state of the system.
  
* ``check diskspace `` \
  \
  Check the disk usage of the system.

* ``check dns `` \
  \
  Check DNS configuration.
  The file *whitelistDNS* contains all authorized DNS IP adresses.
  The script check if the current DNS adress is in this whitelist. 

* `` check proxy `` \
\
Check the configuration of the proxy.

* ``check sudoers`` \
\
Check the list of sudoers.

* ``check daemon `` \
\
List all deamons processes.


## Scan  of your system 

* ``scan rootkit `` \
\
Detect the presence of rootkits.

* ``scan antivirus all `` \
\
Detect viruses within predifined set of files (binaries,home) .

* ``scan antivirus binaries `` \
\
Detect viruses within binaries.

* ``scan antivirus home `` \
\
Detect viruses within user file system.

* ``scan antivirus [path/to/directory]`` \
\
Detect viruses within a path.







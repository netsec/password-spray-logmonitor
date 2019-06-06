# Monitor Failed Logins for Password Spraying

A very basic Bash script to monitor for password spraying attacks. The script tallies a count of failed login attempts for all users and datetime stamps of the last failed logins.

<p align="center">
  <img src="/doc/spray.png">
</p>

This is mainly a personal exercise in shell scripting. Log monitoring can be a relatively weak approach for protection when compared to preventative controls such as ```fail2ban```.

The script is not efficient as it stands. A work in progress. 

## Core Commands Used

A list of usernames is grep'd from the ```/etc/passwd``` file. The script filters user from system accounts based on UID. This can easily be replaced with something like ```getent``` which could be configured to return usernames of users within LDAP, for example.  

Failed login attempts are extracted from the ```/var/log/btmp``` logfile using the ```lastb``` command, remembering to pass the ```-w``` option to return the username in **full** for matching to the list of usernames described above. 

## General Usage

As the script is reading from ```/etc/passwd``` and ```/var/log/btmp``` it requires ```sudo``` privileges in order to run.

THe script could be run using something like the ```watch``` command. 

E.g. ```>$ sudo watch ./passwordFailsMonitor.sh``` (by default will re-run the script every two seconds) 

## Built With

* [GNU Bash](http://www.gnu.org/software/bash/)

## Authors

* **Andrew Houlbrook** - *Initial work* - [AndrewHoulbrook](https://github.com/andrewhoulbrook)
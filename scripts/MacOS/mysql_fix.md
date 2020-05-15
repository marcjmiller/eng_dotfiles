**Here are detailed instructions for getting rid of MySQL from MacOS then reinstalling with Brew**

**Remove MySQL completely**  
`ps -ax | grep mysql`  
stop and kill any running MySQL processes  

`sudo rm /usr/local/mysql`  
`sudo rm -rf /usr/local/var/mysql`  
`sudo rm -rf /usr/local/mysql*`  
`sudo rm ~/Library/LaunchAgents/homebrew.mxcl.mysql.plist`  
`sudo rm -rf /Library/StartupItems/MySQLCOM`  
`sudo rm -rf /Library/PreferencePanes/My*`  
`launchctl unload -w ~/Library/LaunchAgents/homebrew.mxcl.mysql.plist`  
edit /etc/hostconfig and remove the line MYSQLCOM=-YES-  

`rm -rf ~/Library/PreferencePanes/My*`  
`sudo rm -rf /Library/Receipts/mysql*`  
`sudo rm -rf /Library/Receipts/MySQL*`  
`sudo rm -rf /private/var/db/receipts/*mysql*`  
`sudo rm -rf /tmp/mysql*`  
try to run mysql, it shouldn't work, mysql is removed! 


**Brew install MySQL**  
`brew doctor`  
fix any errors reported from above command, then

`brew remove mysql`  
`brew cleanup`  
`brew update`  
`brew install mysql`  
`unset TMPDIR`  

**to start MySQL to test**  
`mysql.server start`  


run the commands Brew suggests, add MySQL to launchctl so it automatically launches at startup
mysql should now work and be running all the time as expected
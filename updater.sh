#phpservermonitor updater
# Developed by petrk94 - https://github.com/petrk94
#
# requirements 
# PHP
# cURL
# grep
# unzip
#
# used code:
# cURL github API url: https://stackoverflow.com/questions/24987542/is-there-a-link-to-github-for-downloading-a-file-in-the-latest-release-of-a-repo

echo Save config.php 
mv config.php config.php.keep
echo done!

# remove old files except config.php.keep
echo remove old files
find . -type f ! -iname "*.keep" -delete
rm -rf cron/ docs/ puphpet/ src/ static/

echo Download latest Version of PHPServerMonitor
echo latest Version is:
curl -s https://api.github.com/repos/phpservermon/phpservermon/releases/latest | grep browser_download_url | cut -d '/' -f 8


#Set if question whether ready to proceed update
echo Do you want download the update and install? Y/N

#extract url from latest zip file to download
downloadfile=$(curl -s https://api.github.com/repos/phpservermon/phpservermon/releases/latest | grep "zipball" | cut -d '"' -f 4)

#download latest version zip file and save it with wget as update.zip
wget -O update.zip "$downloadfile"
unzip update.zip

# move all files and directories from new created phpservermon directory, to the directory above with the native phpservermon installation
mv phpservermon*/* .
# remove phpservermon directory
rm -rf phpservermon*
# restore original config.php back from config.php.keep
mv config.php.keep config.php

# run php composer.phar install
php composer.phar install

echo Update finished!
echo Please check the installation
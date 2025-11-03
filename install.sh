#!/bin/sh
datenow=`date +"%Y-%m-%d_%H-%M-%S"`
if [ ! -z "$datenow" ]; then
  cp ~/.zshrc ~/.zshrc.backup.${datenow}
  cp ~/.aliases ~/.aliases.backup.${datenow}
  cp ~/.exports ~/.exports.backup.${datenow}
else
echo "Couldn't properly name backups with their date! they will be like: ~/.zshrc-zsimplebkp"
  cp ~/.zshrc ~/.zshrc-zsimplebkp
  cp ~/.aliases ~/.aliases-zsimplebkp
  cp ~/.exports /.exports-zsimplebkp
fi

git clone https://github.com/vipau/zsimple.git
cd zsimple

cp zshrc ~/.zshrc
cp aliases ~/.aliases
cp exports ~/.exports

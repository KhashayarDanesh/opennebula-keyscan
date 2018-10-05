#!/bin/sh
set -e
git_repo="your git repo address - with ssh clone method"
echo "Welcome to ssh-config-sync setup"
sleep 0.2
echo "please note, you have to run this script in your workspace."
sleep 0.2
id
echo "setup process will start in 5 seconds."
sleep 5
echo "starting step 1 : Backing up your current ssh-config (also moving it to backup folder)"
sleep 2
if [ ! -d $HOME/.ssh/ ]; then
    echo "~/.ssh/ folder does not exist or there are ownership issues. the program will wnd now, consider creating .ssh or fix the permissions"
    ls -la ~/.ssh/
    exit
fi
if [ ! -d "$HOME/.ssh/config-backup/" ]; then
    mkdir $HOME/.ssh/config-backup
fi
cp ~/.ssh/config ~/.ssh/config-backup/config-`date +%F`
if [ ! -f "$HOME/.ssh/config-backup/config-`date +%F`" ]; then
    echo "unfortunately the backup cannot be created, consider troubleshooting the issue, now the program will close."
    exit
else
    echo "Backup has been successfully created and kept under ~/.ssh/config-backup/config-`date +%F`"
    echo "rm $HOME/.ssh/config"
fi
sleep 2
echo "starting step 2 : Cloning ssh-config repository to your workspace"
if [ ! -d ../ssh-config ]; then
    cd ../ && git clone -b dev $git_repo
    echo "the repository has successfully been cloned"
    cd ./ssh-config-sync
    git branch -b $USER
    git commit
else
    cd ../ssh-config && git pull
    echo "The direcory existed. git pull has been performed."
    git checkout -b $USER
    git commit
fi
sleep 2
echo "Starting Step 3 : symlinking files to ~/.ssh"
cd ../ssh-config
ln -s ./config ~/.ssh/config
ln -s ./config.d ~/.ssh/config.d
cd ../ssh-config-sync
sleep 2
echo "Creating Sync-Configuration for scheduled sync"
workspace="`cd ../ && pwd `"
cat << EOF > ssh-key-sync.sh
workdir = ${workspace}
cd $workspace/ssh-config
current-branch=`git branch | grep \* | cut -d ' ' -f2`
git add .
git commit -m "Auto commit on $USER's Computer at `date +%y-%m-%d-%H-%M-%S`"
git push origin $USER
git fetch origin master && git merge $USER
EOF
echo "symlinking ssh-key-sync to executables path on macintosh - ~/binaries and on linux /usr/local/bin"
chmod +x ssh-key-sync.sh
if [ "`uname`" != "Linux" ]; then
    sudo ln -s `pwd`/ssh-key-sync.sh $HOME/binaries/ssh-key-sync
else
    sudo ln -s `pwd`/ssh-key-sync.sh /usr/local/bin/ssh-key-sync
fi
echo "Done!"
echo "Now add the following line to your user's crontab"
echo "0 0,10,12,14,16,18,20 * * * ssh-key-sync"

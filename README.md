# ssh-config-sync

*** WORK IN PROGRESS ***

A small script for syncing ssh-config git repo and team member's local ssh-config.

### Disclaimer:

THIS SCRIPT IS DOING STUFF WITH YOUR SSH KEYS IT BACKS UP EVERYTHING BEFORE CHANGES, BUT MAKE SURE HOW IT WORKS AND WHAT IT DOES BEFORE USING IT.

### Requirements:

	1 - Cron 

	2 - having created `~/.ssh`

	3 - placing your git repository's ssh-clone address in line `3` of `setup.sh`

### 1 - Clone the ssh-config-sync repo to your workspace

### 2 - Make sure there are no ownership problems with your `~/.ssh` directory.

### 3 - Run the `setup.sh` Script.
The script will :
 
	1 - Backup your own ssh-config file and do a date-tagged backup under ~/ssh/config-backup.

	2 - Remove the current ssh-config.

	3 - Clone the ssh-config from Gitlab.

	4 - Create a branch under your unix username in ssh-config repository.

	4 - Symlinks `/ssh-config/config.d/` and `/ssh-config/config` `to ~/.ssh/config.d/` and `~/.ssh/config`

	5 - Create ssh-key-sync.sh and symlink it to your executables path (based on os, for mac it's `~/binaries` and for linux we'll use `/usr/local/bin`

	6 - Shows you the right command to put in your crontab

### Note: 
	To sync manually, just simply run `ssh-key-sync` in your terminal

### 4 - The `ssh-key-sync.sh`.
The script does:

	1 - (Backup) commits and pushes the changes made in the your branch ( which is named as your unix username ) with an automatic commit message. 

	2 - (Sync) fetches the master branch and merges it with your own branch.
 

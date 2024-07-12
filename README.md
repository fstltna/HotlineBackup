# Hotline backup script (1.0.0)
Creates a backup of your Hotline server

---

1. Edit the settings at the top of hotlinebackup.pl if needed
2. create a cron job like this:

        1 1 * * * /home/hotlineuser/HotlineBackup/hotlinebackup.pl

3. This will back up your Hotline installation at 1:01am each day, and keep the last 5 backups.


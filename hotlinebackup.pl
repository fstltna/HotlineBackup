#!/usr/bin/perl

# Set these for your situation
my $MTDIR = "/home/hotlineuser/HotlineFiles";
my $BACKUPDIR = "/home/hotlineuser/backups";
my $TARCMD = "/bin/tar czf";
my $VERSION = "1.0.0";
my $OPTION_FILE = "/home/hotlineuser/.cmbackuprc";
my $DOSNAPSHOT = 0;
my $FILEEDITOR = $ENV{EDITOR};

if ($FILEEDITOR eq "")
{
	$FILEEDITOR = "/usr/bin/nano";
}

# Get if they said a option
my $CMDOPTION = shift;

if (defined $CMDOPTION)
{
	if ($CMDOPTION ne "-snapshot")
	{
		print "Unknown command line option: '$CMDOPTION'\nOnly allowed option is '-snapshot'\n";
		exit 0;
	}
}

sub SnapShotFunc
{
	print "Backing up Hotline files (snapshot): ";
	if (-f "$BACKUPDIR/snapshot.tgz")
	{
		unlink("$BACKUPDIR/snapshot.tgz");
	}
	system("$TARCMD $BACKUPDIR/snapshot.tgz $MTDIR > /dev/null 2>\&1");
	print "\nBackup Completed.\n";
}

#-------------------
# No changes below here...
#-------------------

if ((defined $CMDOPTION) && ($CMDOPTION eq "-snapshot"))
{
	$DOSNAPSHOT = -1;
}

print "HotlineBackup.pl version $VERSION\n";
if ($DOSNAPSHOT == -1)
{
	print "Running Manual Snapshot\n";
}
print "==============================\n";

if (! -d $BACKUPDIR)
{
	print "Backup dir $BACKUPDIR not found, creating...\n";
	system("mkdir -p $BACKUPDIR");
}
if ($DOSNAPSHOT == -1)
{
	SnapShotFunc();
	exit 0;
}

print "Moving existing backups: ";

if (-f "$BACKUPDIR/hotlinebackup-5.tgz")
{
	unlink("$BACKUPDIR/hotlinebackup-5.tgz") or warn "Could not unlink $BACKUPDIR/hotlinebackup-5.tgz: $!";
}

my $FileRevision = 4;
while ($FileRevision > 0)
{
	if (-f "$BACKUPDIR/hotlinebackup-$FileRevision.tgz")
	{
		my $NewVersion = $FileRevision + 1;
		rename("$BACKUPDIR/hotlinebackup-$FileRevision.tgz", "$BACKUPDIR/hotlinebackup-$NewVersion.tgz");
	}
	$FileRevision -= 1;
}

print "Done\nCreating New Backup: ";
system("$TARCMD $BACKUPDIR/hotlinebackup-1.tgz $MTDIR");
print "Done\n";

exit 0;

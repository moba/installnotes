#! /bin/bash
# Usage: sa-education-false-negatives
#
# Purpose: inject into 'sa-learn --spam' the mail:
#     * arrived (modified, really) less than $MAX_DAYS days ago, and more than
#       $MIN_DAYS days ago
#     * located in the $SPAM_DIR Maildir folders
# If run as a daily cronjob, one should use: $MAX_DAYS - $MIN_DAYS = 1
#
# Background: this is only useful if your mail users move the false negatives
# (spams not recognized by spamassassin) to the dedicated Maildir folder. Also,
# this script will re-inject the spams already detected by SA into sa-learn, who
# will ignore them.
#
# Warning: the Maildir tree is supposed to be organized like this :
#     $MAIL_ROOT_DIR
#        / domain1.tld
#            / mailbox1 / $MAILDIR_ROOT
#            / mailbox2 / $MAILDIR_ROOT
#        / domain2.tld
#            / mailbox3 / $MAILDIR_ROOT
# If it's not the case, you have to adjust the 'find' command below.
#
# https://techstdout.boum.org/SpamAssassinCollectiveEducation/sa-education-false-negatives


#
##
### Configuration variables

MAIL_ROOT_DIR='/var/vmail'
MAILDIR_ROOT='Maildir'
SPAM_DIR='.Junk'
MIN_DAYS=2
MAX_DAYS=3

#
##
### Main
### We copy the interesting emails to a temporary directory, since it's more
# effective to run sa-learn once on a directory than once per email.

# Create a temporary directory, exit if it fails.
TMP_DIR=`mktemp -d -t sa-education-false-negatives.XXXXXX` || exit 1

# Copy the interesting emails to the temporary directory.
find $MAIL_ROOT_DIR/*/*/$MAILDIR_ROOT/$SPAM_DIR/cur/ \
    -type f \
    -mtime -$MAX_DAYS \
    -mtime +$MIN_DAYS \
    -exec cp {} $TMP_DIR \;

# Inject these emails into sa-learn.
sa-learn --spam $TMP_DIR

# Clean.
rm -rf $TMP_DIR


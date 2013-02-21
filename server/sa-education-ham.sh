#! /bin/bash
# Usage: sa-education-ham
#
# Purpose: inject into 'sa-learn --ham' the mail :
#     * whose file status has been modified in the last $THRESHOLD_DAYS days
#     * located in any subfolder of $MAIL_ROOT_DIR
#     * that has been replied to
#
# Background: any anti-spam bayesian filter, in order to be efficient, has to
# be educated by as much as ham as spam emails. Our assertion is : a spam is
# never replied to => an email that has been replied to is ham.
#
# https://techstdout.boum.org/SpamAssassinCollectiveEducation/sa-education-false-negatives

#
##
### Configuration variables

MAIL_ROOT_DIR='/var/vmail'
THRESHOLD_DAYS=7
DEBUG=1

#
##
### Main
### We copy the interesting emails to a temporary directory, since it's more
# effective to run sa-learn once on a directory than once per email.

# Create a temporary directory, exit if it fails.
TMP_DIR=`mktemp -d -t sa-education-ham.XXXXXX` || exit 1

# Copy the interesting emails to the temporary directory.
find $MAIL_ROOT_DIR \
    -type f \
    -mtime -$THRESHOLD_DAYS \
    -name '*,R*' \
    -exec cp {} $TMP_DIR \;

# Inject these emails into sa-learn.
sa-learn --ham $TMP_DIR

# Clean.
rm -rf $TMP_DIR


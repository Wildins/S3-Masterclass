#!/bin/sh
#
# Function to restore config file if backed up
cleanup () {
  mv ${CONFIG}.bk $CONFIG >/dev/null 2>&1
}
# Variables
CONFIG=$HOME/.aws/config
FILESIZE=1GB
FILENAME=${FILESIZE}file
BUCKET='<YOURBUCKETHERE>'
trap `cleanup` 0 1 2 15
#
# Main program
#
# Backup configuration
cp $CONFIG ${CONFIG}.bk
# 
#
# Create file. Ensure your system supports truncate (may need to install it!)
truncate -s $FILESIZE $FILENAME
#
# Without transfer acceleration enabled upload the file
echo "=======================Uploading the file to S3 End Point  =============================================="
time aws s3 cp $FILENAME s3://${BUCKET}-oz
#
# Now enable transfer accleration
aws configure set default.s3.use_accelerate_endpoint true
echo "=======================Uploading the file to transfer accelerated end point ============================="
time aws s3 cp $FILENAME s3://${BUCKET}-oz
#
# Restore old config file
cleanup

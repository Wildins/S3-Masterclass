#!/bin/sh
# 
# This program will create a 1gb file and then upload it to s3 both sequentially and in parallel using 20MB and 5MB
# chunks
#
# NB: This script assumes you have a config file stored under $HOME/.aws
#
#
# Function to restore config file if backed up
cleanup () {
  mv ${CONFIG}.bk $CONFIG >/dev/null 2>&1
}
# Variables
CONFIG=$HOME/.aws/config
FILESIZE=1GB
FILENAME=${FILESIZE}file
BUCKET="<YOURBUCKETHERE>"
trap `cleanup` 0 1 2 15
#
# Main program
#
# Backup configuration
cp $CONFIG ${CONFIG}.bk
#
# Create a file ready for upload
truncate -s $FILESIZE $FILENAME
# Set parameters
# Sequential upload at 20MB first
aws configure set default.s3.max_concurrent_requests 1
aws configure set default.s3.multipart_threshold  20MB
aws configure set default.s3.multipart_chunksize  20MB
echo "=======================Uploading the file in 20MB chunks SEQUENTIALLY (single thread)=============================================="
time aws s3 cp $FILENAME s3://$BUCKET
# Now in parallel
aws configure set default.s3.max_concurrent_requests 10 
aws configure set default.s3.multipart_threshold  20MB
aws configure set default.s3.multipart_chunksize  20MB
echo "=======================Uploading the file in 20MB chunks in PARALLEL (10 threads)================================================="
time aws s3 cp $FILENAME s3://$BUCKET
#
# 5MB
aws configure set default.s3.max_concurrent_requests 1
aws configure set default.s3.multipart_threshold  5MB
aws configure set default.s3.multipart_chunksize  5MB
echo "=======================Uploading the file in 5MB chunks SEQUENTIALLY (single thread)=============================================="
time aws s3 cp $FILENAME s3://$BUCKET
aws configure set default.s3.max_concurrent_requests 10
aws configure set default.s3.multipart_threshold  5MB
aws configure set default.s3.multipart_chunksize  5MB
echo "=======================Uploading the file in 5MB chunks in PARALLEL (10 threads)================================================="
time aws s3 cp $FILENAME s3://$BUCKET
# Restore old config file
cleanup
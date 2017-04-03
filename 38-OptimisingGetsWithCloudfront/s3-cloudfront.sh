#!/bin/sh
#
# Main program
# 
# Note that this program requires a 200MB file. If you want to create one you can do so with
# the following command (and then upload it to your bucket)
# 
# truncate -s 200MB 200mbfile
#
# Without CF
echo "=======================Performing GET from S3 End Point =============================================="
time wget -q http://<YOURS3ENDPOINT>/200mbfile
# With CF
echo "=======================Performing GET from CloudFront   =============================================="
time wget -q http://<YOURCFENDPOINT>/200mbfile
import boto3
from botocore.client import ClientError
s3 = boto3.resource('s3')

def lambda_handler(event, context):
    # Test to ensure our event is S3
    if event["detail"]["eventName"] != 'CreateBucket':
        print("This is not a CreateBucket Event!")
        return
    else:
        #Simply delete the bucket if it still exists
        #Grab the bucket name from the event
        bucketname = event["detail"]["requestParameters"]["bucketName"]
        bucket = s3.Bucket(bucketname)
        #print bucket.name
        # Does it exist
        try:
            s3.meta.client.head_bucket(Bucket=bucket.name)
            # Loop through and delete objects and then delete the bucket
            for key in bucket.objects.all():
               key.delete()
            bucket.delete()
            print("Bucket " + bucket.name + " removed")
            return
        except ClientError as e:
            # If a client error is thrown, then check that it was a 404 error.
            # If it was a 404 error, then the bucket does not exist.
            error_code = int(e.response['Error']['Code'])
            if error_code == 404:
                print("Bucket " + bucket.name + " does not exist")
                return
            else:
                print "Unknown Error"
                return

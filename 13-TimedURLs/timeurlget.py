import boto
conn = boto.connect_s3()
url = conn.generate_url(30, 'GET', bucket='<YOURBUCKETHERE>', key='<YOUROBJECTHERE>')
print url

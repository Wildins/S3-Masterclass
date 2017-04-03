import boto
conn = boto.connect_s3()
url = conn.generate_url(30, 'PUT', bucket='<YOURBUCKETHERE>', key='<YOUROBJECTHERE>')
print url

# Aws.config(access_key_id:     ENV['AWS_ACCESS_KEY_ID'],
#            secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'] )
#
# S3_BUCKET_PNS = Aws::S3.new.buckets[ENV['S3_BUCKET_PNS']]
s3 = Aws::S3::Resource.new region: ENV['AWS_REGION'] || "us-west-2"

S3_BUCKET_PNS = s3.bucket(ENV['S3_BUCKET_PNS'])

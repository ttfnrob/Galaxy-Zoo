#!/usr/bin/env ruby

require 'aws-sdk'
AWS.config access_key_id: ENV['S3_ACCESS_ID'], secret_access_key: ENV['S3_SECRET_KEY']
s3 = AWS::S3.new
bucket = s3.buckets['www.galaxyzoo.org']

bucket.objects['index.html'].write file: 'public/index.html', acl: :public_read, content_type: 'text/html', cache_control: 'no-cache, must-revalidate'

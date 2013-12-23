#!/bin/sh

#cat bucket_list | while read date time bucket other;
#do
#  echo === $bucket ===
#  bucket_name=`echo $bucket | sed -e 's_s3://__'`
#  [ -d $bucket_name ] || mkdir $bucket_name
#  s3cmd ls --recursive $bucket > $bucket_name/list
#done

#for i in */list; do grep -q 2013 $i || wc -l $i; done

#s3cmd ls | awk '{print $3}' |
#  while read bucket; do 
#    printf "$bucket: "
#    s3cmd ls $bucket | wc -l
#  done


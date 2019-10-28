#!/bin/bash

FILEPATH=/tmp/lighthouse_score
FILENAME=$(date "+%Y-%m-%d-%H-%M-%S").html
S3_PATH=s3://$AWS_S3_BUCKET/$FILENAME


echo "running lighthouse score against: " $URL
sudo -u chrome lighthouse --chrome-flags="--headless --disable-gpu --no-sandbox" --no-enable-error-reporting --output html --output-path $FILEPATH/$FILENAME $URL


if { [ ! -z "$AWS_ACCESS_KEY_ID" ] && [ "$AWS_ACCESS_KEY_ID" == "EMPTY" ]; } ||
  { [ ! -z "$AWS_SECRET_ACCESS_KEY" ] && [ "$AWS_SECRET_ACCESS_KEY" == "EMPTY" ]; } || 
  { [ ! -z "$AWS_DEFAULT_REGION" ] && [ "$AWS_DEFAULT_REGION" == "EMPTY" ]; } || 
  { [ ! -z "$S3_PATH" ] && [ "$S3_PATH" == "EMPTY" ]; } ;
then 
    printf "\nYou can find the lighthouse score result html file on your host machine in the mapped volume directory.\n" 
else
    echo "uploading lighthouse score result html file to S3 Bucket: $S3_PATH ..."
    aws s3 cp $FILEPATH/$FILENAME $S3_PATH
    if [ ! -z $AWS_S3_LINK_TTL ] && [ $AWS_S3_LINK_TTL == "EMPTY" ]; 
    then
        printf "\r\nSee the results of this run at (valid 24hrs (default) till the link expires):\n\n\r"
        aws s3 presign $S3_PATH --expires-in 86400 
        printf "\n"
    else
        printf "\n\rSee the results of this run at (valid $AWS_S3_LINK_TTL till the link expires):\n\n\r"
        aws s3 presign $S3_PATH --expires-in $AWS_S3_LINK_TTL
        printf "\n"
    fi
fi;


PERFORMANCE_SCORE=$(cat $FILEPATH/$FILENAME | grep -Po \"id\":\"performance\",\"score\":\(.*?\)} | sed 's/.*:\(.*\)}.*/\1/g')
if [ $(echo "$PERFORMANCE_SCORE > $LIGHTHOUSE_SCORE_THRESHOLD"|bc) -eq "1" ];
then
    echo "The Lighthouse Score is $PERFORMANCE_SCORE which is greater than $LIGHTHOUSE_SCORE_THRESHOLD, proceed with the CI/CD Pipeline..."
    exit 0
else
    echo "The Lighthouse Score is $PERFORMANCE_SCORE which is smaller than $LIGHTHOUSE_SCORE_THRESHOLD, DON'T proceed with the CI/CD Pipeline. Exiting now."
    exit 1
fi;
#!/bin/bash

set -e # Exit immediately if a command returns error

# Variables
STACK_NAME='RootStack'
ROOT_TEMPLATE='root-template.yaml'
OUTPUT_TEMPLATE='packaged-root-template.yaml'
TEMPLATE_BUCKET='phoenix-kata-bucket' # Please change this to your own S3 bucket for packaging CloudFormation templates.
REGION='us-east-1'
WEB_SERVER_IMAGE='ami-0fe472d8a85bc7b0e'
WEBSITE_BUCKET='my-website-source-phoenix' # Please change this to your own S3 bucket for sample website source packages.
DB_CON_STRING='DBStringParam'
# Package the nested templates and produce an output template from the root template
aws cloudformation package \
    --template $ROOT_TEMPLATE \
    --s3-bucket $TEMPLATE_BUCKET \
    --output-template-file $OUTPUT_TEMPLATE \
    --region $REGION

# Deploy the output template of the package command
aws cloudformation deploy \
    --template-file $OUTPUT_TEMPLATE \
    --stack-name $STACK_NAME \
    --parameter-overrides WebServerImage=$WEB_SERVER_IMAGE DBStringParam='DBStringParam'\
    --capabilities CAPABILITY_NAMED_IAM \
    --region $REGION
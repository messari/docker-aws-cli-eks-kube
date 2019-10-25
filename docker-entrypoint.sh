#!/bin/sh
set -e

aws eks --region $AWS_REGION update-kubeconfig --name $EKS_NAME

exec "$@"

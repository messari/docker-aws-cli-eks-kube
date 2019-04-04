#!/bin/sh
set -e

aws eks --region us-east-1 update-kubeconfig --name $EKS_NAME

exec "$@"

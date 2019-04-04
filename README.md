# messari/aws-cli-eks-kube

A aws-cli, eks, kubectl, and helm docker image. Intended for CI/CD usage.

## Setup

1. Create an AWS CLI user with EKS permissions
2. Add that AWS user's ARN to your kubernetes cluster https://stackoverflow.com/questions/50791303/kubectl-error-you-must-be-logged-in-to-the-server-unauthorized-when-accessing

## Usage

`kubectl get pod`

```bash
docker run -e"AWS_DEFAULT_REGION=us-east-1" -e "AWS_ACCESS_KEY_ID=ABC" -e"AWS_SECRET_ACCESS_KEY=ABC" -e "EKS_NAME=ABC" messari/aws-cli-eks-kube kubectl get pod
```

`helm ls`

```bash
docker run -e"AWS_DEFAULT_REGION=us-east-1" -e "AWS_ACCESS_KEY_ID=ABC" -e"AWS_SECRET_ACCESS_KEY=ABC" -e "EKS_NAME=ABC" messari/aws-cli-eks-kube helm ls
```

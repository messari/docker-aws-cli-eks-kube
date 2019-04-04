build:
	docker build -t messari/aws-cli-eks-kube .
	docker tag messari/aws-cli-eks-kube messari/aws-cli-eks-kube:latest

push:
	docker push messari/aws-cli-eks-kube:latest

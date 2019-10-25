FROM python:alpine

ARG CLI_VERSION=1.16.138

RUN apk add --no-cache bash=5.0.0-r0
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# aws-cli for configuring k8 auth
RUN apk -uv add --no-cache curl=7.66.0-r0 groff=1.22.4-r0 jq=1.6-r0 less=551-r0 && \
    pip install --no-cache-dir awscli==$CLI_VERSION

WORKDIR /aws

# auth for eks
RUN curl -o aws-iam-authenticator https://amazon-eks.s3-us-west-2.amazonaws.com/1.12.7/2019-03-27/bin/linux/amd64/aws-iam-authenticator
RUN chmod +x ./aws-iam-authenticator
RUN mv aws-iam-authenticator /usr/local/bin

# kubectl
RUN curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl"
RUN chmod +x ./kubectl
RUN mv kubectl /usr/local/bin

# helm
ENV HELM_VERSION=2.15.1
ENV HELM_SHASUM="4bc1ec87efa27eda155261d261b7e1cad763bd2ee2c1db9d9c74efb53f7d2a46  helm-v${HELM_VERSION}-linux-386.tar.gz"
RUN curl -LO https://storage.googleapis.com/kubernetes-helm/helm-v${HELM_VERSION}-linux-386.tar.gz \
  && echo "${HELM_SHASUM}" | sha256sum -c \
  && tar --strip=1 -xzf ./*.tar.gz linux-386/helm -C /usr/local/bin \
  && rm ./*.tar.gz

ENV HELM_HOME=/usr/local/helm
RUN apk add --no-cache git=2.22.0-r0 \
  && mkdir -p /usr/local/helm/plugins \
  && helm plugin install https://github.com/futuresimple/helm-secrets --version 2.0.2

# kubeseal
RUN wget https://github.com/bitnami-labs/sealed-secrets/releases/download/v0.9.2/kubeseal-linux-amd64 \
  && install -m 755 kubeseal-linux-amd64 /usr/local/bin/kubeseal

COPY docker-entrypoint.sh /aws/docker-entrypoint.sh

ENTRYPOINT ["/aws/docker-entrypoint.sh"]

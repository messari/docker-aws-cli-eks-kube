FROM python:alpine

ARG CLI_VERSION=1.16.138

# aws-cli for configuring k8 auth
RUN apk -uv add --no-cache curl groff jq less && \
    pip install --no-cache-dir awscli==$CLI_VERSION

WORKDIR /aws

# auth for eks
RUN curl -o aws-iam-authenticator https://amazon-eks.s3-us-west-2.amazonaws.com/1.12.7/2019-03-27/bin/linux/amd64/aws-iam-authenticator
RUN chmod +x ./aws-iam-authenticator
RUN mv aws-iam-authenticator /usr/local/bin

# kubectl
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
RUN chmod +x ./kubectl
RUN mv kubectl /usr/local/bin

# helm
ENV HELM_VERSION=2.13.1
ENV HELM_SHASUM="b90303f1b4e867e23dd0a5b0a663dfb5eb3b60d8b4196072bb9ca2bee7bf0637  helm-v${HELM_VERSION}-linux-386.tar.gz"
RUN curl -LO https://storage.googleapis.com/kubernetes-helm/helm-v${HELM_VERSION}-linux-386.tar.gz \
  && echo "${HELM_SHASUM}" | sha256sum -c \
  && tar --strip=1 -xzf *.tar.gz linux-386/helm -C /usr/local/bin \
  && rm *.tar.gz

ADD docker-entrypoint.sh /aws/docker-entrypoint.sh

ENTRYPOINT ["/aws/docker-entrypoint.sh"]

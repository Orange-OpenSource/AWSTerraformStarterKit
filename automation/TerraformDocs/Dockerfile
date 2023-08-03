FROM alpine:3.18.0

ARG TERRAFORM_DOCS_VERSION=0.16.0
ARG TERRAFORM_DOCS_OS=linux
ARG TERRAFORM_DOCS_ARCH=amd64

RUN apk add --no-cache --purge wget

RUN wget -O /tmp/terraform-docs.tar.gz https://github.com/terraform-docs/terraform-docs/releases/download/v${TERRAFORM_DOCS_VERSION}/terraform-docs-v${TERRAFORM_DOCS_VERSION}-${TERRAFORM_DOCS_OS}-${TERRAFORM_DOCS_ARCH}.tar.gz \
    && tar -xvzf /tmp/terraform-docs.tar.gz \
    && mv terraform-docs /usr/local/bin \
    && chmod +x /usr/local/bin/terraform-docs \
    && rm /tmp/terraform-docs* \
    && mkdir /workdir \
    && chmod 777 /workdir

ENTRYPOINT ["terraform-docs"]
WORKDIR /workdir

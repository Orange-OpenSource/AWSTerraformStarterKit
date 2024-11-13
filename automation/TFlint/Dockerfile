FROM alpine:3.18.0

ARG TFLINT_VERSION=0.54.0
ARG TFLINT_OS=linux
ARG TFLINT_ARCH=amd64

RUN apk add --no-curl --purge wget

RUN wget -O /tmp/tflint.zip https://github.com/terraform-linters/tflint/releases/download/v${TFLINT_VERSION}/tflint_${TFLINT_OS}_${TFLINT_ARCH}.zip \
    && unzip /tmp/tflint.zip \
    && mv tflint /usr/local/bin \
    && chmod +x /usr/local/bin/tflint \
    && rm /tmp/tflint* \
    && mkdir /workdir \
    && chmod 777 /workdir

ENTRYPOINT ["tflint"]
WORKDIR /workdir

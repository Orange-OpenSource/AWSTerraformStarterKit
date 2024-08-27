ARG BASH_VERSION=5
FROM "docker.io/bash:${BASH_VERSION}"

# Runtime dependencies
RUN apk add --no-cache --purge \
    curl \
    aws-cli \
    python3 py3-pip \
    git \
    wget \
    openssh-client \
    make \
    zip zip-doc \
    curl curl-doc \
    build-base gcc-doc \
    libffi-dev zlib-dev linux-headers \
    openssl \
    jq \
    ;

RUN apk --update --no-cache --allow-untrusted --repository http://dl-cdn.alpinelinux.org/alpine/edge/community add \
    corkscrew \
    && rm -rf /var/cache/apk/* \
          /tmp/* \
          /var/tmp/*

ARG TFENV_VERSION=3.0.0

RUN wget -O /tmp/tfenv.tar.gz "https://github.com/tfutils/tfenv/archive/refs/tags/v${TFENV_VERSION}.tar.gz" \
    && tar -C /tmp -xf /tmp/tfenv.tar.gz \
    && mv "/tmp/tfenv-${TFENV_VERSION}/bin"/* /usr/local/bin/ \
    && mkdir -p /usr/local/lib/tfenv \
    && mv "/tmp/tfenv-${TFENV_VERSION}/lib" /usr/local/lib/tfenv/ \
    && mv "/tmp/tfenv-${TFENV_VERSION}/libexec" /usr/local/lib/tfenv/ \
    && mkdir -p /usr/local/share/licenses \
    && mv "/tmp/tfenv-${TFENV_VERSION}/LICENSE" /usr/local/share/licenses/tfenv \
    && rm -rf /tmp/tfenv* \
    && mkdir /var/tfenv \
    && touch /var/tfenv/version \
    && echo "latest" > /var/tfenv/version \
    && chmod 777 -R /var/tfenv \
    ;
ENV TFENV_ROOT /usr/local/lib/tfenv

ENV TFENV_CONFIG_DIR /var/tfenv

ENV TFENV_TERRAFORM_VERSION ""

VOLUME /var/tfenv

RUN apk add --no-cache --purge \
                git \
                bash \
                build-base \
                libffi-dev \
                openssl-dev \
                bzip2-dev \
                zlib-dev \
                xz-dev \
                readline-dev \
                sqlite-dev \
                tk-dev \
                linux-headers \
                vim \
                ;

RUN apk add --no-cache cosign \
                tenv --repository=http://dl-cdn.alpinelinux.org/alpine/edge/testing/ \
                ;
# install pyenv pyenv-doctor pyenv-installer pyenv-update pyenv-virtualenv pyenv-which-ext
RUN curl https://raw.githubusercontent.com/pyenv/pyenv-installer/master/bin/pyenv-installer | bash
RUN mv /root/.pyenv /pyenv
# these need to go into your .bashrc
ENV PYENV_ROOT "/pyenv"
ENV PATH "$PYENV_ROOT/bin:$PATH"
RUN eval "$(pyenv init -)"
RUN eval "$(pyenv virtualenv-init -)"
RUN pyenv install 3.8 3.9 3.10 3.11 3.12
ENV PATH "$PYENV_ROOT/bin:$PYENV_ROOT/shims:$PATH"

ENTRYPOINT ["/usr/local/bin/terraform"]

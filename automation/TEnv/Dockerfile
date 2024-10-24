ARG ALPINE_VERSION=3.20
FROM "alpine:${ALPINE_VERSION}"

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

ARG TENV_VERSION=v3.2.4

RUN wget -O /tmp/tenv.apk "https://github.com/tofuutils/tenv/releases/download/${TENV_VERSION}/tenv_${TENV_VERSION}_386.apk" \
    && apk add --allow-untrusted /tmp/tenv.apk \
    ;

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

ENTRYPOINT ["/usr/bin/tenv"]

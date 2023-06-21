#ts:skip=AC_DOCKER_0041 Skip

ARG DRIFTCTL_IMAGE_TAG

FROM snyk/driftctl:${DRIFTCTL_IMAGE_TAG}

RUN apk add --no-cache aws-cli
RUN apk add --no-cache jq

USER app

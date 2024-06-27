#ts:skip=AC_DOCKER_0041 Skip
ARG IMAGE_VERSION=3.11
FROM alpine:${IMAGE_VERSION}

# Install python3 and other deps
RUN apk add --no-cache python3
RUN pip3 --no-cache-dir install pip==22.2.2 --no-cache

# Set needed env vars
ENV SCRIPTS_DIR /scripts
ENV TEMPLATES_DIR /templates
ENV VARIABLES_DIR /variables

# Create folders
RUN mkdir /templates/
RUN mkdir /variables/
RUN mkdir /scripts/

RUN pip3 --no-cache-dir install jinja2-cli[yaml,toml,xml]==0.8.2
RUN pip3 --no-cache-dir install Jinja2==3.1.2

# Copy extra scripts: embedded render
COPY ./render.py $SCRIPTS_DIR/entities/render.py
COPY ./compute_deps.py $SCRIPTS_DIR/entities/compute_deps.py
RUN chmod +x $SCRIPTS_DIR/entities/render.py

ENTRYPOINT ["jinja2"]

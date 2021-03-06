#
# (c) 2019 Jared Allard <jaredallard@outlook.com>
#

FROM mhart/alpine-node:13

# Setup the core user
# for some reason ping has the GID we want -- so use that
RUN adduser -D -u 999 -G ping media

# "static" stuff
ENTRYPOINT ["/usr/bin/docker-entrypoint"]
ENV DEBUG media:*
WORKDIR /stack

# Fix SSL. See https://github.com/Yelp/dumb-init/issues/73
# Install our deps
RUN apk add --no-cache ca-certificates curl \
&&  update-ca-certificates \
&&  apk add --no-cache dumb-init bash jq git

# Copy over the entry-point
COPY docker-entrypoint.sh /usr/bin/docker-entrypoint

# Weird state issues?
RUN rm -rf /stack /config && \
    mkdir /stack /config && \
    chown -R media:ping /stack /config && \
    chmod -R 755 /stack /config

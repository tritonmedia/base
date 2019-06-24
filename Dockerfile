#
# (c) 2018 Jared Allard <jaredallard@outlook.com>
#

FROM mhart/alpine-node:12

# Setup the core user
# for some reason ping has the GID we want -- so use that
RUN adduser -D -u 999 -G ping media

# "static" stuff
ENTRYPOINT ["/usr/bin/docker-entrypoint"]
ENV DEBUG media:*
WORKDIR /stack

# Fix SSL. See https://github.com/Yelp/dumb-init/issues/73
RUN apk add --no-cache ca-certificates wget \
&&  update-ca-certificates

# Install our deps
RUN apk add --no-cache dumb-init redis bash jq git

# Copy over the entry-point
COPY docker-entrypoint.sh /usr/bin/docker-entrypoint

# Weird state issues?
RUN rm -rf /stack /config && \
    mkdir /stack /config && \
    chown -R media:ping /stack /config && \
    chmod -R 755 /stack /config

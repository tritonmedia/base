FROM debian:12.1-slim

ENTRYPOINT [ "/bin/bash" ]
CMD [ "/usr/bin/s3-mounter" ]

# gcsfuse
RUN export DEBIAN_FRONTEND=noninteractive; apt-get update && apt-get install -y --no-install-recommends curl wget ca-certificates gnupg2 \
&&  echo "deb http://packages.cloud.google.com/apt gcsfuse-jessie main" | tee /etc/apt/sources.list.d/gcsfuse.list \
&&  curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - \
&&  apt-get update; apt-get install -y --no-install-recommends fuse gcsfuse

# goofys & catfs
RUN wget https://github.com/kahing/goofys/releases/download/v0.23.1/goofys -O /usr/bin/goofys \
&&  wget https://github.com/kahing/catfs/releases/download/v0.8.0/catfs -O /usr/bin/catfs \
&&  chmod +x /usr/bin/goofys /usr/bin/catfs

# user
RUN addgroup --gid 999 media \
&&  adduser --uid 999 --gid 999 --disabled-password --gecos "" media

COPY . /usr/bin

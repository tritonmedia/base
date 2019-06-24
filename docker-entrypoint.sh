#!/usr/bin/dumb-init /bin/bash
#
# (c) 2018 Jared Allard <jaredallard@outlook.com>
#

CMD=$2

# Enable service debugging
export DEBUG="media:*"
export DEBUG_COLORS=true

echo "Started: $(date)"
echo "opts: $*"
echo "user: $(whoami)"

if [[ -z "$RABBITMQ" ]]; then
  export RABBITMQ="amqp://user:bitnami@triton-rabbitmq"
  echo "WARN: \$RABBITMQ undefined, defauting to prod config..."
fi

if [[ -z "$MEDIA" ]]; then
  export MEDIA="http://twilight:8001"
  echo "WARN: \$MEDIA undefined, defaulting to prod config..."
fi

# Check for kubernetes mounted secrets
if [[ ! -e "/mnt/config/config.yaml" ]]; then
  echo "WARN: Config not found at /mnt/config, using environment variable"

  if [[ -z "$CONFIG" ]]; then
    echo "ERROR: Config not defined."
    exit 2
  fi

  echo "INFO: inserting base64 decoded config into ./config/config.yaml"
  echo "$CONFIG" | base64 -d > /config/config.yaml
else
  ln -svf /mnt/config/config.yaml /config/config.yaml
fi


echo "INFO: bootstrap complete."

echo "cmd: $(pwd)"
echo -n "exec: "
if [[ -z "$CMD" ]]; then
  echo "node index.js"
  exec node index.js
else
  echo "${CMD}"
  "$CMD"
fi

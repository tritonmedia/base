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

if [[ -z "$REDIS" ]]; then
  export REDIS="redis://media-redis:6379"
  echo "WARN: \$REDIS undefined, defaulting to prod config..."
fi

if [[ -z "$MEDIA" ]]; then
  export MEDIA="http://twilight:8001"
  echo "WARN: \$MEDIA undefined, defaulting to prod config..."
fi

REDIS_HOST=$(echo $REDIS | sed 's/redis:\/\///g' | awk -F ':' '{ print $1 }')
REDIS_PORT=$(echo $REDIS | awk -F ':' '{ print $3 }')

echo "INFO: waiting for redis '$REDIS' ($REDIS_HOST:$REDIS_PORT)"
PING_RESPONSE=""
while [[ $PING_RESPONSE != "PONG" ]]; do

  # From: https://github.com/vishnubob/wait-for-it/blob/master/wait-for-it.sh
  TIMEOUT_PATH=$(realpath "$(which timeout)")
  BUSYTIMEFLAG=""
  if [[ $TIMEOUT_PATH =~ "busybox" ]]; then
    BUSYTIMEFLAG="-t"
  fi

  PING_RESPONSE="$(timeout $BUSYTIMEFLAG 3 redis-cli -h $REDIS_HOST -p $REDIS_PORT PING)"
  echo "$PING_RESPONSE"
  sleep 1
done
echo "INFO: redis is up"

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

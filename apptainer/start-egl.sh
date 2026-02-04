#!/bin/bash

SINGULARITY_SELKIES_SCRATCH_HOME="egl-home"
mkdir -pm755 "${SINGULARITY_SELKIES_SCRATCH_HOME}"

SINGULARITY_SELKIES_LOGS_DIR="images/logs"
rm "${SINGULARITY_SELKIES_LOGS_DIR}"/*.log 2> /dev/null || echo 'No existing log files to remove'
mkdir -pm755 "${SINGULARITY_SELKIES_LOGS_DIR}"

NGINX_PORT=7000
SELKIES_PORT=8081
SELKIES_METRICS_HTTP_PORT=9081
SELKIES_TURN_PORT=2000
SELKIES_TURN_HOST="127.0.0.1"
TURN_EXTERNAL_IP="127.0.0.1"

TMP_DIR="/tmp/docker-nvidia-egl-desktop-$(date +%Y%m%d%H%M%S)-$(tr -dc 'A-Za-z0-9' < /dev/urandom 2>/dev/null | head -c 24)"
if [ -d "${TMP_DIR}" ]; then
  echo "Error: Temporary directory ${TMP_DIR} already exists. Exiting to prevent conflicts."
  exit 1
fi
mkdir -pm755 "${TMP_DIR}"

singularity exec --nv \
  --pid \
  --env DISPLAY=:0 \
  --env NGINX_PORT=${NGINX_PORT} \
  --env SELKIES_PORT=${SELKIES_PORT} \
  --env SELKIES_METRICS_HTTP_PORT=${SELKIES_METRICS_HTTP_PORT} \
  --env SELKIES_TURN_PORT=${SELKIES_TURN_PORT} \
  --env SELKIES_TURN_HOST=${SELKIES_TURN_HOST} \
  --env TURN_EXTERNAL_IP=${TURN_EXTERNAL_IP} \
  --no-mount cwd,tmp \
  --bind "${TMP_DIR}:/tmp" \
  --bind "${SINGULARITY_SELKIES_LOGS_DIR}:/var/log/" \
  --home "${SINGULARITY_SELKIES_SCRATCH_HOME}:/home/ubuntu" \
  --env "TZ=UTC,DISPLAY_SIZEW=1920,DISPLAY_SIZEH=1080,DISPLAY_REFRESH=60,DISPLAY_DPI=96,DISPLAY_CDEPTH=24,PASSWD=mypasswd,SELKIES_ENCODER=nvh264enc,SELKIES_VIDEO_BITRATE=8000,SELKIES_FRAMERATE=60,SELKIES_AUDIO_BITRATE=128000,SELKIES_BASIC_AUTH_PASSWORD=lithium" \
  images/docker-nvidia-egl-desktop-nonroot.sif \
  /usr/bin/supervisord

rm -r "${TMP_DIR}"

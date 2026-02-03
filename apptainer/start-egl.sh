#!/bin/bash

SINGULARITY_SELKIES_SCRATCH_HOME="egl-home"
mkdir -pm755 "${SINGULARITY_SELKIES_SCRATCH_HOME}"

SINGULARITY_SELKIES_LOGS_DIR="images/logs"
rm "${SINGULARITY_SELKIES_LOGS_DIR}"/*.log 2> /dev/null || echo 'No existing log files to remove'
mkdir -pm755 "${SINGULARITY_SELKIES_LOGS_DIR}"

mkdir -pm755 /tmp/docker-nvidia-egl-desktop-tmp

NGINX_PORT=7000
SELKIES_PORT=8081
SELKIES_METRICS_HTTP_PORT=9081
SELKIES_TURN_PORT=3478

singularity exec --nv \
  --pid \
  --env DISPLAY=:0 \
  --env NGINX_PORT=${NGINX_PORT} \
  --env SELKIES_PORT=${SELKIES_PORT} \
  --env SELKIES_METRICS_HTTP_PORT=${SELKIES_METRICS_HTTP_PORT} \
  --env SELKIES_TURN_PORT=${SELKIES_TURN_PORT} \
  --no-mount cwd,tmp \
  --bind /tmp/docker-nvidia-egl-desktop-tmp:/tmp \
  --bind "${SINGULARITY_SELKIES_LOGS_DIR}:/var/log/" \
  --home "${SINGULARITY_SELKIES_SCRATCH_HOME}:/home/ubuntu" \
  --env "TZ=UTC,DISPLAY_SIZEW=1920,DISPLAY_SIZEH=1080,DISPLAY_REFRESH=60,DISPLAY_DPI=96,DISPLAY_CDEPTH=24,PASSWD=mypasswd,SELKIES_ENCODER=nvh264enc,SELKIES_VIDEO_BITRATE=8000,SELKIES_FRAMERATE=60,SELKIES_AUDIO_BITRATE=128000,SELKIES_BASIC_AUTH_PASSWORD=lithium" \
  images/docker-nvidia-egl-desktop-nonroot.sif \
  /usr/bin/supervisord

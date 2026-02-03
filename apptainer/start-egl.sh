#!/bin/bash

export SINGULARITY_SELKIES_SCRATCH_HOME="images/egl-home"
mkdir -pm755 "${SINGULARITY_SELKIES_SCRATCH_HOME}"

export SINGULARITY_SELKIES_LOGS_DIR="images/logs"
rm "${SINGULARITY_SELKIES_LOGS_DIR}"/*.log 2> /dev/null || echo 'No existing log files to remove'
mkdir -pm755 "${SINGULARITY_SELKIES_LOGS_DIR}"

mkdir -pm755 /tmp/docker-nvidia-egl-desktop-tmp

singularity shell --nv \
  --pid \
  --no-mount cwd,tmp \
  --bind /tmp/docker-nvidia-egl-desktop-tmp:/tmp \
  --bind "${SINGULARITY_SELKIES_LOGS_DIR}:/var/log/" \
  --home "${SINGULARITY_SELKIES_SCRATCH_HOME}:/home/ubuntu" \
  --env "TZ=UTC,DISPLAY_SIZEW=1920,DISPLAY_SIZEH=1080,DISPLAY_REFRESH=60,DISPLAY_DPI=96,DISPLAY_CDEPTH=24,PASSWD=mypasswd,SELKIES_ENCODER=nvh264enc,SELKIES_VIDEO_BITRATE=8000,SELKIES_FRAMERATE=60,SELKIES_AUDIO_BITRATE=128000,SELKIES_BASIC_AUTH_PASSWORD=lithium" \
  --security="apparmor:unprivileged_userns" \
  images/docker-nvidia-egl-desktop-nonroot.sif

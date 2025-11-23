#!/bin/bash

# singularity build --fakeroot images/docker-nvidia-egl-desktop-update.sif update.def
# singularity build --fakeroot images/docker-nvidia-egl-desktop-nvidia.sif nvidia.def
singularity build --fakeroot images/docker-nvidia-egl-desktop-nonroot.sif configs.def

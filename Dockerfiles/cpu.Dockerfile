# Copyright 2019 The TensorFlow Authors. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# ============================================================================
#
# THIS IS A GENERATED DOCKERFILE.
#
# This file was assembled from multiple pieces, whose use is documented
# throughout. Please refer to the TensorFlow dockerfiles documentation
# for more information.

# --------------------------------- MODIFIED ---------------------------------
#ARG UBUNTU_VERSION=18.04
ARG UBUNTU_VERSION=20.04 
# For Python 3.8
# ------------------------------------ END -----------------------------------

FROM ubuntu:${UBUNTU_VERSION} as base

RUN apt-get update && apt-get install -y curl

# See http://bugs.python.org/issue19846
ENV LANG C.UTF-8

# ---------------------------------- ADDED -----------------------------------
# Could not build without it
ENV TZ=Europe/London
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
# ------------------------------------ END -----------------------------------

# --------------------------------- MODIFIED ---------------------------------
# RUN apt-get update && apt-get install -y \
#     python3 \
#     python3-pip

# RUN python3 -m pip --no-cache-dir install --upgrade \
#     "pip<20.3" \
#     setuptools

# Bump to python 3.8 and avoid a pip error during build
RUN apt-get update && apt-get install -y \
    python3.8 \
    python3-pip

RUN python3 -m pip --no-cache-dir install --upgrade \
    pip \
    setuptools
# ------------------------------------ END -----------------------------------

# Some TF tools expect a "python" binary
RUN ln -s $(which python3) /usr/local/bin/python

# ---------------------------------- ADDED -----------------------------------
# Allow wheel to work for h5py.whl
RUN apt-get install pkg-config -y \
    libhdf5-dev 
# ------------------------------------ END -----------------------------------

# --------------------------------- MODIFIED ---------------------------------
# Options:
#   tensorflow
#   tensorflow-gpu
#   tf-nightly
#   tf-nightly-gpu
# Set --build-arg TF_PACKAGE_VERSION=1.11.0rc0 to install a specific version.
# Installs the latest version by default.
# ARG TF_PACKAGE=tensorflow
ARG TF_PACKAGE_VERSION=
# RUN python3 -m pip install --no-cache-dir ${TF_PACKAGE}${TF_PACKAGE_VERSION:+==${TF_PACKAGE_VERSION}}

# Install tensorflow from local wheel package build
COPY tensorflow-${TF_PACKAGE_VERSION}-cp38-none-linux_aarch64.whl /temp/tensorflow-${TF_PACKAGE_VERSION}-cp38-none-linux_aarch64.whl
RUN python3 -m pip install /temp/tensorflow-${TF_PACKAGE_VERSION}-cp38-none-linux_aarch64.whl
RUN rm /temp/tensorflow-${TF_PACKAGE_VERSION}-cp38-none-linux_aarch64.whl

# ------------------------------------ END -----------------------------------

COPY bashrc /etc/bash.bashrc
RUN chmod a+rwx /etc/bash.bashrc

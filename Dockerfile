FROM ubuntu:16.04
WORKDIR /temp

ENV \ 
    COMPILER=ldc \
    COMPILER_VERSION=1.17.0 \
    DPLUG_VERSION=9.0.9

# Install packages needed for installing ldc and dplug-build
RUN apt update \
    && apt install wget -y\
    && apt install xz-utils -y \
    && apt install git -y \
    && apt install libxml2-dev -y \
    && apt install build-essential -y \
    && apt install libx11-dev -y

# Download and install ldc2
RUN wget "https://github.com/ldc-developers/ldc/releases/download/v${COMPILER_VERSION}/${COMPILER}2-${COMPILER_VERSION}-linux-x86_64.tar.xz" \
    && tar -xvf "${COMPILER}2-${COMPILER_VERSION}-linux-x86_64.tar.xz" \
    && cp -r "${COMPILER}2-${COMPILER_VERSION}-linux-x86_64"/* /usr/local/

# Download dplug, build dplug-build and install it to /usr/local/bin
RUN git clone -b "v${DPLUG_VERSION}" https://www.github.com/AuburnSounds/dplug.git --depth=1 \
    && dub --root=dplug/tools/dplug-build -a x86_64 -b release-nobounds "--compiler=${COMPILER}2" || true \
    && mv dplug/tools/dplug-build/dplug-build /usr/local/bin/dplug-build

# Cleanup unneeded files
RUN rm -rf /temp/*

VOLUME ["/src"]
VOLUME ["/VST2_SDK"]
WORKDIR /src

RUN export VST2_SDK=/VST2_SDK

COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]

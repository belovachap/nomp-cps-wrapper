FROM debian:bullseye AS build
RUN rm -f /etc/apt/apt.conf.d/docker-clean; echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' > /etc/apt/apt.conf.d/keep-cache
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    apt-get update && apt-get install -y \
    build-essential \
    autoconf \
    automake \
    libtool \
    pkg-config \
    libcurl4-openssl-dev \
    libudev-dev \
    libusb-1.0-0-dev \
    zlib1g-dev \
    git
RUN git clone https://github.com/kanoi/cgminer.git
WORKDIR cgminer
RUN CFLAGS="-O2 -march=native -fcommon" ./autogen.sh --enable-gekko --without-curses
RUN make -j$(nproc)

FROM debian:bullseye
ENV TERM=xterm
RUN rm -f /etc/apt/apt.conf.d/docker-clean; echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' > /etc/apt/apt.conf.d/keep-cache
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    apt-get update && apt-get install -y \
    libcurl4 \
    libudev1 \
    libusb-1.0.0 \
    && rm -rf /var/lib/apt/lists/*
COPY --from=build /cgminer/cgminer /usr/local/bin/cgminer
ENTRYPOINT ["cgminer"]
CMD ["-n"]

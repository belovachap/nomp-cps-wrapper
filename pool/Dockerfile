FROM node:12 AS build

RUN rm -f /etc/apt/apt.conf.d/docker-clean; echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' > /etc/apt/apt.conf.d/keep-cache
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    echo "deb http://archive.debian.org/debian stretch main" > /etc/apt/sources.list \
    && apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    libsodium-dev \
    libboost-system-dev
WORKDIR /app
RUN git clone https://github.com/ihavenoface/cryptocurrency-pool-server.git . \
    && git checkout febc6a2a7582c6bdf532b4b18140cb480c6ff519 \
    && rm -rf .git \
    && npm install

FROM node:12 AS final

RUN rm -f /etc/apt/apt.conf.d/docker-clean; echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' > /etc/apt/apt.conf.d/keep-cache
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    echo "deb http://archive.debian.org/debian stretch main" > /etc/apt/sources.list \
    && apt-get update && apt-get install -y --no-install-recommends \
    libsodium18 \
    libboost-system1.62.0
WORKDIR /app
COPY --from=build /app/ /app/
COPY ./app/ /app/
CMD ["init.js"]

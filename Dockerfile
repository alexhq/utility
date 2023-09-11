ARG K8S_VERSION=1.28.1

FROM alpine/k8s:${K8S_VERSION} as k8s-stage

FROM ubuntu:20.04

ENV DEBIAN_FRONTEND="noninteractive"

COPY --from=k8s-stage --chown=root:bin /usr/bin/eksctl /usr/local/bin
COPY --from=k8s-stage --chown=root:bin /usr/bin/helm /usr/local/bin
COPY --from=k8s-stage --chown=root:bin /usr/bin/kubectl /usr/local/bin

ENV PATH=/usr/local/bin:${PATH}

LABEL org.opencontainers.image.source https://github.com/alexhq/utility

RUN apt-get update -yq \
    && apt-get install --no-install-recommends -yq \
    apt-transport-https \
    apt-utils \
    ca-certificates \
    curl \
    git \
    gpg \
    gpg-agent \
    jq \
    make \
    nmap \
    postgresql \
    python3-pip \
    python3-setuptools \
    sudo \
    unzip \
    wget \
    && apt-get upgrade -yq --no-install-recommends \
    && apt-get autoremove -yq \
    && apt-get autoclean -yq \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/*

CMD [ "/bin/bash" ]
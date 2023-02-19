# =============== Install Dependencies

FROM ubuntu:18.04 as base

RUN apt-get update &&  DEBIAN_FRONTEND=noninteractive apt-get install -y -q \
  build-essential \
  sudo \
  tofrodos \
  iproute2 \
  gawk \
  net-tools \
  expect \
  libncurses5-dev \
  tftpd \
  update-inetd \
  libssl-dev \
  flex \
  bison \
  libselinux1 \
  gnupg \
  wget \
  socat \
  gcc-multilib \
  libidn11 \
  libsdl1.2-dev \
  libglib2.0-dev \
  lib32z1-dev \
  libgtk2.0-0 \
  libtinfo5 \
  xxd \
  screen \
  pax \
  diffstat \
  xvfb \
  xterm \
  texinfo \
  gzip \
  unzip \
  cpio \
  chrpath \
  autoconf \
  lsb-release \
  libtool \
  libtool-bin \
  locales \
  kmod \
  git \
  rsync \
  bc \
  u-boot-tools \
  python \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

RUN dpkg --add-architecture i386 &&  apt-get update &&  \
      DEBIAN_FRONTEND=noninteractive apt-get install -y -q \
      zlib1g:i386 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# make a Ubuntu user

ARG HOST_UID

RUN adduser --disabled-password --gecos '' ubuntu --uid ${HOST_UID} && \
  usermod -aG sudo ubuntu && \
  echo "ubuntu ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

ENV HOME /home/ubuntu

RUN locale-gen en_US.UTF-8 && update-locale
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8

WORKDIR /home/ubuntu

# =============== Petalinux Installation

FROM base as petalinux
USER ubuntu:ubuntu

ARG PETA_RUN_FILE

COPY --chown=ubuntu:ubuntu accept-eula.sh ${HOME}/accept-eula.sh
COPY --chown=ubuntu:ubuntu ${PETA_RUN_FILE} ${HOME}/${PETA_RUN_FILE}

WORKDIR /tmp

# run the install
RUN sudo mkdir -p /opt/Xilinx && \
  sudo chown ubuntu:ubuntu /opt/Xilinx && \
  sudo -u ubuntu -i /home/ubuntu/accept-eula.sh ${HOME}/${PETA_RUN_FILE} /opt/Xilinx/petalinux && \
  rm -f ${HOME}/${PETA_RUN_FILE} ${HOME}/accept-eula.sh \
  rm -f ${HOME}/petalinux_installation_log

# make /bin/sh symlink to bash instead of dash:
RUN echo "dash dash/sh boolean false" | sudo debconf-set-selections
RUN sudo DEBIAN_FRONTEND=noninteractive dpkg-reconfigure dash

RUN echo "source /opt/Xilinx/petalinux/settings.sh" >> ${HOME}/.bashrc

RUN sudo usermod -a -G dialout ubuntu

WORKDIR ${HOME}

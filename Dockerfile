FROM debian:stretch

RUN set -e;\
  apt-get update;\
  apt-get install \
    ca-certificates \
    curl \
    git \
    gzip \
    python \
    ssh \
    wget \
    unzip \
  -y;\
  wget -q 'https://s3.amazonaws.com/aws-cli/awscli-bundle.zip';\
  unzip awscli-bundle.zip;\
  awscli-bundle/install -i /opt/aws-cli -b /usr/bin/aws;\
  rm -fR awscli-bundle.zip awscli-bundle;\
  apt-get remove wget -y;\
  apt-get autoremove -y;\
  rm -vfR /var/lib/apt/lists/*;\
  addgroup --system --gid 1000 docker;\
  adduser --home /docker --gecos '' --shell /bin/bash --gid 1000 --system --disabled-login --uid 1000 docker;

USER docker
WORKDIR /docker
SHELL ["/bin/bash", "-c"]

ENV ASDF_VERSION=0.7.2 \
    JAVA_VERSION="openjdk-11.0.1" \
    GRADLE_VERSION="5.5"

RUN set -e;\
  git clone https://github.com/asdf-vm/asdf.git /docker/.asdf --branch "v${ASDF_VERSION}";\
  source /docker/.asdf/asdf.sh;\
  asdf plugin-add java;\
  asdf install java "${JAVA_VERSION}";\
  asdf global java "${JAVA_VERSION}";\
  asdf plugin-add gradle;\
  asdf install gradle "${GRADLE_VERSION}";\
  asdf global gradle "${GRADLE_VERSION}";

# Derived from: https://github.com/uphold/docker-litecoin-core/blob/master/0.18/Dockerfile
# Pulling the latest official Ubuntu which we will base our new image from.
# docker scan --file Dockerfile ubuntu:latest - Tested 93 dependencies for known vulnerabilities, found 17 Low severity vulnerabilities. (There are no fixed versions for Ubuntu:20.04)
FROM ubuntu:latest

LABEL maintainer "Matt Martinez" "mattkm.eth"

# Add normal user, update all present packages, install two additional packages to download + verify LTC tarball
RUN useradd -r litecoin \
  && apt-get update -y \
  && apt-get install -y curl gnupg \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Exit immediately if a command moving forward exits with non-zero status (failure)
# Import the LTC core dev signing key from the public gpg servers (DONT TRUST.. VERIFY!!)
RUN set -ex \
  && for key in \
    FE3348877809386C \
  ; do \
    gpg --no-tty --keyserver pgp.mit.edu --recv-keys "$key" || \
    gpg --no-tty --keyserver keyserver.pgp.com --recv-keys "$key" || \
    gpg --no-tty --keyserver ha.pool.sks-keyservers.net --recv-keys "$key" || \
    gpg --no-tty --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys "$key" ; \
  done


# Set LTC environment variables
ENV LITECOIN_VERSION=0.18.1
ENV LITECOIN_DATA=/home/litecoin/.litecoin

# Download LTC core and its gpg signature
RUN curl -SLO https://download.litecoin.org/litecoin-${LITECOIN_VERSION}/linux/litecoin-${LITECOIN_VERSION}-x86_64-linux-gnu.tar.gz \
  && curl -SLO https://download.litecoin.org/litecoin-${LITECOIN_VERSION}/linux/litecoin-${LITECOIN_VERSION}-linux-signatures.asc \
  && gpg --verify litecoin-${LITECOIN_VERSION}-linux-signatures.asc \
  && grep $(sha256sum litecoin-${LITECOIN_VERSION}-x86_64-linux-gnu.tar.gz | awk '{ print $1 }') litecoin-${LITECOIN_VERSION}-linux-signatures.asc \
  && tar --strip=2 -xzf *.tar.gz -C /usr/local/bin \
  && rm *.tar.gz

# Set LTC config file
VOLUME ["/home/litecoin/.litecoin"]

# run LTC daemon
CMD ["litecoind"]

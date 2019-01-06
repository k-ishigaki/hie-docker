FROM ubuntu:18.04

RUN apt-get update && apt-get install -y \
  build-essential \
  curl \
  git \
  libicu-dev libtinfo-dev libgmp-dev

RUN curl -sSL https://get.haskellstack.org/ | sh

# prepare env for hie installation
ENV PATH $PATH:/root/.local/bin

# install hie to /root/.local/bin
RUN git clone https://github.com/haskell/haskell-ide-engine --recursive \
  && cd haskell-ide-engine \
  && stack install cabal-install \
  && cabal update \
  && stack install

# use multi stage build to reduce image size
FROM ubuntu:18.04

ENV PATH $PATH:/root/.local/bin

COPY --from=0 /root/.local/bin/hie /root/.local/bin/

FROM haskell:8.6.5
LABEL maintainer "Kazuki Ishigaki <k-ishigaki@frontier.hokudai.ac.jp>"

RUN apt-get update

# add sudo user
RUN apt-get install -y sudo
RUN groupadd -g 1000 developer \
  && useradd -g developer -G sudo -m -s /bin/bash user \
  && echo 'user:pass' | chpasswd

RUN echo 'Defaults visiblepw' >> /etc/sudoers
RUN echo 'user ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER user
ENV USER user

# install requirements
RUN sudo apt-get install -y curl xz-utils

# install nix
RUN curl https://nixos.org/nix/install | sh
ENV PATH $PATH:/home/${USER}/.nix-profile/bin/

# setup nix
RUN nix-channel --add https://nixos.org/channels/nixpkgs-unstable \
  && nix-channel --update

# install hie
RUN nix-env -iA nixpkgs.cachix \
  && cachix use all-hies \
  && nix-env -iA selection --arg selector 'p: { inherit (p) ghc865; }' -f https://github.com/infinisil/all-hies/tarball/master

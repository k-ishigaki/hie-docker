FROM nixos/nix

# setup nix
RUN nix-channel --add https://nixos.org/channels/nixpkgs-unstable \
  && nix-channel --update

# install hie
RUN nix-env -iA nixpkgs.cachix \
  && cachix use all-hies \
  && nix-env -iA selection --arg selector 'p: { inherit (p) ghc865; }' -f https://github.com/infinisil/all-hies/tarball/master

# install ghc
RUN nix-env -i ghc-8.6.5

# install stack
RUN nix-env -i stack \
  && stack update
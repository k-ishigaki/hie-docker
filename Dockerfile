FROM nixos/nix
LABEL maintainer "Kazuki Ishigaki <k-ishigaki@frontier.hokudai.ac.jp>"

# install GHC, Stack, Cachix, and HIE
RUN nix-env -iA cachix -f https://cachix.org/api/v1/install && cachix use all-hies \
    && nix-env -i ghc-8.6.5 stack \
    && nix-env -iA unstableFallback.selection --arg selector 'p: { inherit (p) ghc865; }' -f https://github.com/infinisil/all-hies/tarball/master

RUN find ${HOME} -type d | xargs -n 50 -P 4 chmod o+rwx

RUN apk add --no-cache su-exec

ENV USER_ID 0
ENV GROUP_ID 0
RUN { \
	echo '#!/bin/sh -e'; \
	echo 'if [ ${USER_ID} -ne 0 ]; then'; \
	echo '    addgroup -g ${GROUP_ID} -S group'; \
	echo '    adduser -h /root -G group -S -D -H -u ${USER_ID} user'; \
	echo '    chown user:group /root'; \
	echo 'fi'; \
	echo 'exec su-exec ${USER_ID}:${GROUP_ID} "$@"'; \
	} > /entrypoint && chmod +x /entrypoint
ENTRYPOINT [ "/entrypoint" ]

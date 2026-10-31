FROM nixpkgs/nix:nixos-23.11

ARG ZMK_REVISION=8aeaaa66fbb4b94948c8763e06f1920ab0b69480
ENV PATH=/root/.nix-profile/bin:/usr/bin:/bin
ENV ZMK_REVISION=${ZMK_REVISION}

RUN <<EOF
    set -euo pipefail
    nix-env -iA cachix -f https://cachix.org/api/v1/install
    cachix use moergo-glove80-zmk-dev
    mkdir /config
    git init /src
    git -C /src remote add origin https://github.com/darknao/zmk.git
    git -C /src fetch --depth 1 origin "$ZMK_REVISION"
    git -C /src checkout --detach FETCH_HEAD
    cd /src
    nix-shell --run true -A zmk ./default.nix
EOF

COPY --chmod=755 <<EOF /bin/entrypoint.sh
#!/usr/bin/env bash
    set -euo pipefail
    echo "Building from darknao/zmk revision \$ZMK_REVISION" >&2
    echo 'Building Glove80 firmware' >&2
    cd /config
    nix-build ./config --arg firmware 'import /src/default.nix {}' -j2 -o /tmp/combined --show-trace
    install -o "\$UID" -g "\$GID" /tmp/combined/glove80.uf2 ./glove80.uf2
EOF

ENTRYPOINT ["/bin/entrypoint.sh"]

# Run build.sh to use this file

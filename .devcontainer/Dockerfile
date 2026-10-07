FROM ubuntu:20.04

ARG USERNAME=cis3410
ARG USER_UID=1000
ARG USER_GID=${USER_UID}

ENV TZ=Asia/Shanghai

RUN apt-get update -y \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        apt-transport-https \
        build-essential \
        ca-certificates \
        clang \
        dos2unix \
        git \
        m4 \
        opam \
        sudo \
        time \
        tzdata \
        zip \
        zsh \
    && rm -rf /var/lib/apt/lists/* \
    && groupadd --gid ${USER_GID} ${USERNAME} \
    && useradd --uid ${USER_UID} --gid ${USER_GID} -m ${USERNAME} --shell /bin/zsh \
    && echo "${USERNAME} ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/${USERNAME} \
    && chmod 0440 /etc/sudoers.d/${USERNAME}

COPY hack.sh /tmp/hack.sh
RUN dos2unix /tmp/hack.sh \
    && chmod +x /tmp/hack.sh \
    && /tmp/hack.sh

COPY .zshrc /home/${USERNAME}/.zshrc
RUN dos2unix /home/${USERNAME}/.zshrc \
    && chown ${USERNAME}:${USERNAME} /home/${USERNAME}/.zshrc

USER ${USERNAME}

RUN mkdir -p /home/${USERNAME}/.local/state \
    && touch /home/${USERNAME}/.local/state/utop-history \
    && for attempt in 1 2 3; do \
        rm -rf "${HOME}/.opam"; \
        opam init --yes --bare --no-setup --disable-sandboxing default https://opam.ocaml.org && break; \
        if [ "${attempt}" = 3 ]; then exit 1; fi; \
        sleep 5; \
    done \
    && opam switch create 4.14.1 ocaml-base-compiler.4.14.1 \
    && opam install --yes dune menhir num ocaml-lsp-server ocamlformat.0.26.1 utop

ARG BASE_IMAGE=node:24-slim
FROM ${BASE_IMAGE}

# ca-certificates for device-code auth
RUN apt-get update \
 && apt-get install -y --no-install-recommends ca-certificates \
 && rm -rf /var/lib/apt/lists/*

RUN npm install -g --ignore-scripts @earendil-works/pi-coding-agent

# additional software aka dev tools
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
        curl git ripgrep fd-find \
    && rm -rf /var/lib/apt/lists/*

# user setup
RUN userdel --remove node
RUN useradd --create-home --shell /bin/bash pi \
 && mkdir /home/pi/src
USER pi
WORKDIR /home/pi/src

RUN git config --global user.name "pi coding agent" \
 && git config --global user.email "pi-agent@no-mail.com" \
 && git config --global pull.rebase true \
 && git config --global rebase.autoStash true \
 && git config --global branch.master.rebase false \
 && git config --global branch.master.mergeoptions --ff-only \
 && git config --global branch.main.rebase false \
 && git config --global branch.main.mergeoptions --ff-only

 CMD [ "/usr/local/bin/pi" ]

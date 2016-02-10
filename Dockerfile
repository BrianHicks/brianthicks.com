FROM abiosoft/caddy

RUN apk add --update perl

RUN curl -L https://github.com/spf13/hugo/releases/download/v0.15/hugo_0.15_linux_amd64.tar.gz > hugo.tar.gz && \
    tar -xzvf hugo.tar.gz && \
    cp hugo_0.15_linux_amd64/hugo* /usr/local/bin/hugo && \
    rm -rf hugo*

ENV HOOK_SECRET=
ENV DOMAIN=brianthicks.com
ENV REPO=github.com/BrianHicks/brianthicks.com.git
ENV TLS=off

COPY Caddyfile /etc/Caddyfile

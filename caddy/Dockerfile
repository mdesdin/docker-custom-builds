FROM caddy:2.10.0-builder AS builder

RUN xcaddy build \
    --with github.com/caddy-dns/cloudflare \
    --with github.com/WeidiDeng/caddy-cloudflare-ip \
    #--with github.com/hslatman/caddy-crowdsec-bouncer/http \
    #--with github.com/hslatman/caddy-crowdsec-bouncer/layer4 \
    #--with github.com/hslatman/caddy-crowdsec-bouncer/appsec \
    --with github.com/mholt/caddy-events-exec \
    --with github.com/porech/caddy-maxmind-geolocation

RUN apk add curl jq
RUN mkdir -p /opt/bin
RUN curl -L $(curl -s https://api.github.com/repos/stalwartlabs/stalwart/releases/latest?per_page=100 | jq --raw-output '[.assets[] | select(.browser_download_url | test("x86_64-unknown-linux-musl"))][0] | .browser_download_url') | tar xzvf - -C /opt/bin

FROM caddy:2.10.0

RUN apk add --no-cache postgresql-client curl
COPY --from=builder /usr/bin/caddy /usr/bin/caddy
COPY --from=builder --chmod=755 --chown=root:root /opt/bin/stalwart-cli /opt/bin/stalwart-cli
RUN curl -L --create-dirs --output /etc/caddy/Caddyfile https://raw.githubusercontent.com/mdesdin/docker-custom-builds/refs/heads/main/caddy/Caddyfile
RUN curl -L --create-dirs --create-file-mode 0755 --output /scripts/certaction.sh https://raw.githubusercontent.com/mdesdin/docker-custom-builds/refs/heads/main/caddy/scripts/certaction.sh

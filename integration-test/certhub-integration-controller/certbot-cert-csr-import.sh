#!/bin/sh

/usr/bin/env \
    git gau-exec /home/certhub/certs.git \
    git gau-ac \
    git gau-xargs -I{} \
    certhub-message-format {}/certbot-cert \
    rsync -av /home/certhub/input/certbot-cert/ {}/certbot-cert/

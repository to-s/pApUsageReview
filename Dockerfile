FROM jekyll/builder:latest
# This image is cached on the Github Actions VM, so it drastically reduces build time

USER root

RUN apk --no-cache add curl jq

COPY ./pointAp.sh /

CMD chmod +x /pointAp.sh

CMD /pointAp.sh | grep "Ap used"

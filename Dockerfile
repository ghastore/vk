FROM alpine

LABEL "name"="VK: GitHub Tag"
LABEL "description"="Publishing GitHub repository tag in VK."
LABEL "maintainer"="z17 CX <mail@z17.cx>"
LABEL "repository"="https://github.com/ghastore/vk.git"
LABEL "homepage"="https://github.com/ghastore"

COPY *.sh /
RUN apk add --no-cache bash curl jq

ENTRYPOINT ["/entrypoint.sh"]

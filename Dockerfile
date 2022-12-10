FROM alpine

LABEL "name"="VK Share"
LABEL "description"="Share GitHub repository in VK."
LABEL "maintainer"="v77 Development <mail@v77.dev>"
LABEL "repository"="https://github.com/ghastore/vk.git"
LABEL "homepage"="https://github.com/ghastore"

COPY *.sh /
RUN apk add --no-cache bash curl jq

ENTRYPOINT ["/entrypoint.sh"]

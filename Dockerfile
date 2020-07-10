FROM alpine:latest

RUN apk add --no-cache bash curl git jq

COPY ./scrape.sh ./run.sh /scripts/
RUN chmod a+x /scripts/*.sh

# build img command
# docker build -t jankudev/scrape4chan:test .

# docker run -v $(pwd)/img/test:/img -e VOLUME_DEST=/img jankudev/scrape4chan:test
# ENTRYPOINT /usr/bin/scrape.sh "s" "latex" ${VOLUME_DEST}

# docker run -v $(pwd)/img/test:/img -e VOLUME_DEST=/img jankudev/scrape4chan:test
# docker run -v /mnt/c/Users/janku/Pictures/:/dest -e VOLUME_DEST=/dest jankudev/scrape4chan:test
ENTRYPOINT cd /scripts && ./run.sh

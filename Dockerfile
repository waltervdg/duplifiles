FROM alpine:latest
COPY ./monitor.sh /
RUN apk update && apk add bash inotify-tools
RUN mkdir /run/shm
RUN chmod a+rwx /monitor.sh
ENTRYPOINT ["/monitor.sh"]


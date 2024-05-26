FROM golang:1.22-bookworm as builder

ENV APP_USER app
ENV APP_HOME /app
RUN mkdir -p $APP_HOME/build
WORKDIR $APP_HOME/build
ENV GOBIN $APP_HOME

ARG TARGETOS
ARG TARGETARCH

# tag
RUN git clone --depth 1 -b v0.4.3 https://github.com/PowerDNS/lightningstream.git .

# specific commit
# RUN git clone https://github.com/PowerDNS/lightningstream.git . \
#     && git checkout a2417440c1e3c0fb3f985c29763715de3a61769c \
#     && git reset --hard

COPY start.sh $APP_HOME/

RUN go mod download \
  && go install ./cmd/...

WORKDIR $APP_HOME
RUN rm -rf build

FROM debian:bookworm-slim

ENV APP_USER app
ENV APP_HOME /app
WORKDIR $APP_HOME

ENV LOCAL_PORT 8500

COPY --chown=0:0 --from=builder $APP_HOME/lightningstream $APP_HOME/
COPY --chown=0:0 --from=builder $APP_HOME/start.sh $APP_HOME/

RUN apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates procps \
    && apt-get -y clean \
    && rm -rf /var/lib/apt/lists/* \
    && rm /var/log/apt/history.log \
    && rm /var/log/dpkg.log \
    && rm /var/log/apt/term.log \
    && update-ca-certificates

EXPOSE $LOCAL_PORT/tcp $LOCAL_PORT/udp

# ENTRYPOINT [ "/app/lightningstream", "--config", "/app/lightningstream.yaml", "--minimum-pid", "200", "sync" ]
CMD [ "/app/lightningstream", "--config", "/app/lightningstream.yaml", "--minimum-pid", "200", "sync" ]


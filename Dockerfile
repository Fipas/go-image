FROM golang:1.14.6-alpine3.12 AS build

LABEL maintainer="felipefonseca"

ENV APP_HOME /app

WORKDIR $APP_HOME
COPY src src

RUN go build -o bin/hello src/hello.go

FROM busybox AS release 

LABEL maintainer="felipefonseca"

ENV APP_HOME /app 

ARG UNAME=gouser
ARG UID=500
ARG GID=500

RUN addgroup --system --gid $GID $UNAME
RUN adduser --system --uid $UID --ingroup $UNAME --disabled-password --no-create-home $UNAME
USER $UNAME

WORKDIR $APP_HOME
COPY --chown=$UNAME:$UNAME --from=build /app/bin/hello hello

CMD ["/app/hello"]
FROM golang:1.14.6 AS build

LABEL maintainer="felipefonseca"

WORKDIR /app
COPY src src

RUN apt-get update && apt-get install -y upx
RUN go build -ldflags="-s -w" -o bin/hello src/hello.go
RUN upx --brute bin/hello

FROM scratch AS release 

LABEL maintainer="felipefonseca"

WORKDIR /app
COPY --from=build /app/bin/hello hello

CMD ["/app/hello"]
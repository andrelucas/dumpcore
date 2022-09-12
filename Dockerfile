FROM docker.io/alpine:latest as build

RUN apk update && apk add --no-cache build-base
RUN mkdir -p /src
COPY *.c Makefile /src
WORKDIR /src
RUN make clean all

FROM docker.io/alpine:latest
COPY --from=build /dumpcore /dumpcore
ENTRYPOINT ["/dumpcore"]


FROM rust:1.82-alpine AS builder

RUN apk add --no-cache musl-dev

WORKDIR /build
COPY upstream/ .

RUN cargo build --release --bin tmux-mcp-server

FROM alpine:3.19

RUN apk add --no-cache tmux su-exec

COPY --from=builder /build/target/release/tmux-mcp-server /usr/local/bin/tmux-mcp-server
COPY entrypoint.sh /entrypoint.sh

EXPOSE 8090
ENTRYPOINT ["/entrypoint.sh"]
CMD ["/usr/local/bin/tmux-mcp-server"]

# --------------------------
# 构建阶段：Go 编译（alpine 最小化）
# --------------------------
FROM golang:alpine AS builder
WORKDIR /app

# 仅安装 git（go install 必须）
RUN apk add --no-cache git

# 构建 derper
ARG DERP_VERSION=latest
RUN CGO_ENABLED=0 go install -ldflags="-s -w" tailscale.com/cmd/derper@${DERP_VERSION}

# --------------------------
# 运行阶段：distroless:latest（root，最小体积）
# --------------------------
FROM gcr.io/distroless/static-debian12:latest
WORKDIR /app

# 仅创建证书目录
RUN mkdir -p /app/certs

# 复制二进制（仅一个文件）
COPY --from=builder /go/bin/derper /app/derper

# 环境变量
ENV DERP_DOMAIN=your-hostname.com
ENV DERP_CERT_MODE=letsencrypt
ENV DERP_CERT_DIR=/app/certs
ENV DERP_ADDR=:443
ENV DERP_STUN=true
ENV DERP_STUN_PORT=3478
ENV DERP_HTTP_PORT=80
ENV DERP_VERIFY_CLIENTS=false
ENV DERP_VERIFY_CLIENT_URL=""

# 暴露端口
EXPOSE 443/tcp 3478/udp 80/tcp

# 启动命令（exec 格式，无 shell）
CMD ["/app/derper", \
    "--hostname", "${DERP_DOMAIN}", \
    "--certmode", "${DERP_CERT_MODE}", \
    "--certdir", "${DERP_CERT_DIR}", \
    "--a", "${DERP_ADDR}", \
    "--stun", "${DERP_STUN}", \
    "--stun-port", "${DERP_STUN_PORT}", \
    "--http-port", "${DERP_HTTP_PORT}", \
    "--verify-clients", "${DERP_VERIFY_CLIENTS}", \
    "--verify-client-url", "${DERP_VERIFY_CLIENT_URL}"]

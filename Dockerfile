FROM debian:13-slim AS downloader
RUN apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates curl \
    && curl -Lo /tmp/new-api-v1.0.0-rc.45 https://github.com/QuantumNous/new-api/releases/download/v1.0.0-rc.45/new-api-v1.0.0-rc.45 \
    && curl -Lo /tmp/checksums-linux.txt https://github.com/QuantumNous/new-api/releases/download/v1.0.0-rc.45/checksums-linux.txt \
    && (cd /tmp && grep -F 'new-api-v1.0.0-rc.45' checksums-linux.txt | grep -v arm64 | sha256sum -c -) \
    && chmod +x /tmp/new-api-v1.0.0-rc.45

FROM debian:13-slim
RUN apt-get update && apt-get install -y --no-install-recommends ca-certificates && rm -rf /var/lib/apt/lists/*
WORKDIR /app
COPY --from=downloader /tmp/new-api-v1.0.0-rc.45 /app/new-api
ENV PORT=8080 TZ=Asia/Shanghai
EXPOSE 8080
CMD ["/app/new-api"]


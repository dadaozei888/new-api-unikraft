FROM debian:13-slim AS downloader
RUN apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates curl \
    && curl -Lo /tmp/new-api https://github.com/QuantumNous/new-api/releases/download/v1.0.0-rc.45/new-api-v1.0.0-rc.45 \
    && curl -Lo /tmp/checksums-linux.txt https://github.com/QuantumNous/new-api/releases/download/v1.0.0-rc.45/checksums-linux.txt \
    && (cd /tmp && grep new-api-v1.0.0-rc.45 checksums-linux.txt | sha256sum -c -) \
    && chmod +x /tmp/new-api

FROM debian:13-slim
RUN apt-get update && apt-get install -y --no-install-recommends ca-certificates && rm -rf /var/lib/apt/lists/*
WORKDIR /app
COPY --from=downloader /tmp/new-api /app/new-api
ENV PORT=8080 TZ=Asia/Shanghai
EXPOSE 8080
CMD ["/app/new-api"]

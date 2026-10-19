FROM debian:13-slim AS downloader
RUN apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates curl \
    && curl -Lo /tmp/new-api https://github.com/QuantumNous/new-api/releases/download/v1.0.0-rc.45/new-api-v1.0.0-rc.45 \
    && chmod +x /tmp/new-api

FROM debian:13-slim
WORKDIR /app
COPY --from=downloader /tmp/new-api /app/new-api
ENV PORT=8080 TZ=Asia/Shanghai
EXPOSE 8080
CMD ["/app/new-api"]

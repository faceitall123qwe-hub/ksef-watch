FROM python:3.12-slim
# Pango is what WeasyPrint needs to turn the invoice into a PDF.
RUN apt-get update && apt-get install -y --no-install-recommends libpango-1.0-0 libpangoft2-1.0-0 fonts-dejavu-core \
    && rm -rf /var/lib/apt/lists/*
WORKDIR /app
COPY pyproject.toml README.md ./
COPY ksef_watch ksef_watch
RUN pip install --no-cache-dir ".[pdf]"
RUN useradd -m watcher && mkdir /data && chown watcher /data
USER watcher
VOLUME /data
ENTRYPOINT ["ksef-watch"]
CMD ["run", "-c", "/config/config.toml"]

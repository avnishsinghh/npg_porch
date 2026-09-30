ARG BASE_IMAGE=python:3.14-slim
FROM $BASE_IMAGE AS builder

ARG DEBIAN_FRONTEND="noninteractive"

RUN apt-get update && \
    apt-get install -q -y --no-install-recommends \
    build-essential \
    gcc \
    git \
    libsqlite3-dev \
    unattended-upgrades && \
    unattended-upgrade -v

WORKDIR /app

COPY .. .

RUN python -m venv /app && \
    . ./bin/activate && \
    pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir .

FROM $BASE_IMAGE

ARG DEBIAN_FRONTEND
ARG PG_VERSION=18

RUN apt-get update && \
    apt-get install -q -y --no-install-recommends \
    ca-certificates \
    curl \
    postgresql-common && \
    /usr/share/postgresql-common/pgdg/apt.postgresql.org.sh -y

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -q -y --no-install-recommends \
    curl \
    libsqlite3-0 \
    postgresql-${PG_VERSION} \
    sudo \
    tini \
    iproute2 \
    locales && \
    locale-gen en_GB en_GB.UTF-8 && \
    localedef -i en_GB -c -f UTF-8 -A /usr/share/locale/locale.alias en_GB.UTF-8

RUN apt-get install -q -y --no-install-recommends \
    unattended-upgrades && \
    unattended-upgrade -v && \
    apt-get remove -q -y unattended-upgrades && \
    apt-get autoremove -q -y && \
    apt-get clean -q -y && \
    rm -rf /var/lib/apt/lists/*

ENV LANG=en_GB.UTF-8 \
    LANGUAGE=en_GB \
    LC_ALL=en_GB.UTF-8 \
    TZ="Etc/UTC"

ARG APP_USER=apprunner
ARG APP_UID=1000
ARG APP_GID=$APP_UID

WORKDIR /app

RUN groupadd --gid $APP_GID $APP_USER && \
    useradd --uid $APP_UID --gid $APP_GID --shell /bin/bash --create-home $APP_USER

COPY --from=builder --chown=$APP_USER:$APP_GID /app /app

RUN chmod u+x /app/docker/scripts/entrypoint.sh

USER $APP_USER

ARG PORT=8081

ENV PORT=${PORT}

EXPOSE ${PORT}

HEALTHCHECK --interval=30s --timeout=30s --start-period=10s --retries=3 CMD curl -f http://localhost:${PORT} || exit 1

ENTRYPOINT ["/usr/bin/tini", "--"]

CMD ["/app/docker/scripts/entrypoint.sh"]

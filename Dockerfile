FROM alpine:3.8
LABEL maintainer="searx <https://github.com/asciimoo/searx>"
LABEL description="A privacy-respecting, hackable metasearch engine."

EXPOSE 8888
WORKDIR /usr/local/searx
CMD ["python", "searx/webapp.py"]

RUN adduser -D -h /usr/local/searx -s /bin/sh searx searx

COPY requirements.txt ./requirements.txt

RUN apk -U add \
    build-base \
    python \
    python-dev \
    py-pip \
    libxml2 \
    libxml2-dev \
    libxslt \
    libxslt-dev \
    libffi-dev \
    openssl \
    openssl-dev \
    ca-certificates \
 && pip install --upgrade pip \
 && pip install --no-cache -r requirements.txt \
 && apk del \
    build-base \
    python-dev \
    libffi-dev \
    openssl-dev \
    libxslt-dev \
    libxml2-dev \
    openssl-dev \
    ca-certificates \
 && rm -f /var/cache/apk/*

COPY . .

RUN chown -R searx:searx *

USER searx

RUN sed -i "s/127.0.0.1/0.0.0.0/g" searx/settings.yml

STOPSIGNAL SIGINT

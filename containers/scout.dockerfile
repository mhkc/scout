FROM python:3.8-slim

LABEL DESCRIPTION="Containerized version of the Scout interface"
LABEL VERSION="v0.0.2"

COPY requirements* setup* README.md containers/utils/wait-for-it.sh /scout/
COPY scout scout/scout/
WORKDIR /scout

RUN apt-get update && apt upgrade &&                                    \
    apt-get install -y                                                  \
        autoconf automake build-essential                               \
        gcc libbz2-dev libcairo2 libcurl4-gnutls-dev                    \
        libffi-dev libgdk-pixbuf2.0-0 liblzma-dev libpango-1.0-0        \
        libpangocairo-1.0-0 libssl-dev make python3-cffi python3-dev    \
        python3-pip python3-setuptools python3-wheel shared-mime-info   \
        zlib1g-dev openssl ca-certificates &&                           \
    # install scout                                                     \
    pip install --no-cache-dir                                          \
        --requirement requirements.txt                                  \
        --requirement requirements-dev.txt                              \
        --editable . &&                                                 \
    # clean up                                                          \
    rm -rf /var/lib/apt/lists/*
RUN sed -i.bak -e 's/SECLEVEL=2/SECLEVEL=1/' /usr/lib/ssl/openssl.cnf  # workaround for ssl errors

EXPOSE 5000
CMD ["scout", "--host", "db", "--demo", "serve"]

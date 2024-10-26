FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get install -y software-properties-common && \
    add-apt-repository -y ppa:deadsnakes/ppa && \
    apt-get update

RUN apt-get install -y \
    python3.9 \
    virtualenv \
    python3.9-distutils \
    python3-pip \
    postgresql-client \
    libpq-dev \
    sudo \
    git \
    && apt-get clean

RUN groupadd -g 1000 odoo15 && \
    useradd -u 1000 -g odoo15 -m -s /bin/bash odoo15

RUN mkdir -p /opt/odoo15/venv3.9 /opt/odoo15/odoo /etc/odoo15 && \
    chown -R odoo15:odoo15 /opt/odoo15 /etc/odoo15

USER odoo15

RUN python3 -m venv /opt/odoo15/venv3.9 && \
    /opt/odoo15/venv3.9/bin/pip install --upgrade pip && \
    /opt/odoo15/venv3.9/bin/pip install odoo==15.0

COPY nrcsudan.conf /etc/odoo15/nrcsudan.conf

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 8069

ENTRYPOINT ["/entrypoint.sh"]

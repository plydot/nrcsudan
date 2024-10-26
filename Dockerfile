FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get install -y software-properties-common && \
    add-apt-repository -y ppa:deadsnakes/ppa && \
    apt-get update

RUN apt-get install -y \
    python3.9 \
    virtualenv \
    python3-venv \
    python3.9-distutils \
    python3-pip \
    postgresql-client \
    libpq-dev \
    sudo \
    git \
    python3-gevent \
    && apt-get clean

RUN apt-get install -y build-essential libssl-dev libffi-dev python3.9-dev python3-dev libldap2-dev libsasl2-dev

RUN groupadd -g 1000 odoo15 && \
    useradd -u 1000 -g odoo15 -m -s /bin/bash odoo15

RUN mkdir -p /opt/odoo15/venv3.9 /opt/odoo15/odoo /etc/odoo15 && \
    chown -R odoo15:odoo15 /opt/odoo15 /etc/odoo15

RUN cd /opt/odoo15/odoo
COPY . .

USER odoo15

RUN virtualenv /opt/odoo15/venv3.9 -p python3.9 && \
    /opt/odoo15/venv3.9/bin/pip install --upgrade pip && \
    /opt/odoo15/venv3.9/bin/pip install Cython==3.0.0a10 && \
    /opt/odoo15/venv3.9/bin/pip install gevent==20.9.0 --no-build-isolation && \
    /opt/odoo15/venv3.9/bin/pip install -r requirements.txt

RUN cp nrcsudan.conf /etc/odoo15/nrcsudan.conf

COPY entrypoint.sh /etc/odoo15/entrypoint.sh
USER root
RUN chmod +x /etc/odoo15/entrypoint.sh
USER odoo15
EXPOSE 8069

ENTRYPOINT ["/etc/odoo15/entrypoint.sh"]

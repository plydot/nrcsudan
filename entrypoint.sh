#!/bin/bash

# Clone the GitHub repository using the provided authentication token
if [ ! -d "/var/www/production/nrcsudan.lmtpay.com/lmtpay/.git" ]; then
  mkdir -p /var/www/production/nrcsudan.lmtpay.com/lmtpay
  git clone https://${GITHUB_USERNAME}:${GITHUB_TOKEN}@github.com/datapollsolutions/lmtpay.git /var/www/production/nrcsudan.lmtpay.com/lmtpay
fi

# Run Odoo
/opt/odoo15/venv3.9/bin/python3 /opt/odoo15/odoo/odoo-bin -c /etc/odoo15/nrcsudan.conf

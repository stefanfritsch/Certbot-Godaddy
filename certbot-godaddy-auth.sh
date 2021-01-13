#!/bin/bash
#
# certbot-godaddy-auth.sh -- A Certbot Authentication callback script
#
# Copyright (C) 2019 Martijn Veldpaus
# All rights reserved.
#
# This software may be modified and distributed under the terms
# of the BSD license.  See the LICENSE file for details.

SCRIPTDIR=$(dirname -- "$(readlink -f -- "$0")")
echo "SCRIPTDIR: ${SCRIPTDIR}"
source $SCRIPTDIR/api-settings.sh

echo "DOMAIN: ${DOMAIN}"

DNS_REC_TYPE=TXT
DNS_REC_NAME="_acme-challenge."${CERTBOT_DOMAIN%${DOMAIN}}
DNS_REC_NAME=${DNS_REC_NAME%.}
DNS_REC_DATA="$CERTBOT_VALIDATION"

echo Creating ${DNS_REC_TYPE} record ${DNS_REC_NAME} for certificate renewal with value ${DNS_REC_DATA}

echo "${GODADDY_URL}/v1/domains/${DOMAIN}/records"

echo "[{\"data\": \"${DNS_REC_DATA}\", \"name\": \"${DNS_REC_NAME}\", \"type\": \"${DNS_REC_TYPE}\", \"ttl\": 600}]"

curl    -i \
        -X PATCH \
        "${GODADDY_URL}/v1/domains/${DOMAIN}/records" \
        -H "accept: application/json" \
        -H "Content-Type: application/json" \
        -H "Authorization: sso-key ${GODADDY_API_KEY}:${GODADDY_API_SECRET}" \
        -d "[{\"data\": \"${DNS_REC_DATA}\", \"name\": \"${DNS_REC_NAME}\", \"type\": \"${DNS_REC_TYPE}\", \"ttl\": 600}]"

sleep 30s

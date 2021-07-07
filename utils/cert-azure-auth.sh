#!/bin/bash
CREATE_DOMAIN="_acme-challenge.$CERTBOT_DOMAIN"
az network dns record-set txt add-record -g nsalab-prod -z az.skillscloud.company \
    -n ${CREATE_DOMAIN%.az.skillscloud.company} -v $CERTBOT_VALIDATION
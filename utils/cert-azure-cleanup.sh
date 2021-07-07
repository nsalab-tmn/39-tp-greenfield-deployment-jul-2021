#!/bin/bash
CREATE_DOMAIN="_acme-challenge.$CERTBOT_DOMAIN"
az network dns record-set txt delete -g nsalab-prod -z az.skillscloud.company \
    -n ${CREATE_DOMAIN%.az.skillscloud.company} -y
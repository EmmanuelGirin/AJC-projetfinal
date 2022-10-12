#Grab the latest alpine image
FROM python:3.6-alpine

##Declare env variables
ENV ODOO_URL=""
ENV PGADMIN_URL=""

## Install python and pip
RUN apk add --no-cache --update python3 py3-pip bash

##Add dependencies (useful if there are multiple dependencies)
COPY ./requirements/requirements.txt /tmp/requirements.txt

## Install dependencies
RUN pip3 install --no-cache-dir -q -r /tmp/requirements.txt

## Add our code
COPY ./ /opt/ic-webapp

##add our script
RUN chmod +x /opt/ic-webapp/entrypoint.sh

#change directory for execution
WORKDIR /opt/ic-webapp

## Expose Port for Container
EXPOSE 8080

ENTRYPOINT ["/bin/bash", "-c", "./entrypoint.sh"]
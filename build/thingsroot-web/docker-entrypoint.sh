#!/bin/bash

## Thanks
# https://serverfault.com/a/919212
##

set -e

if [[ -z "$SITE_NAME" ]]; then
	export SITE_NAME="ioe.localhost"
fi

if [[ -z "$CLODU_SITE_NAME" ]]; then
	export CLOUD_SITE_NAME="cloud.localhost"
fi

if [[ -z "$MQTT_HOST" ]]; then
	export MQTT_HOST=0.0.0.0
fi

if [[ -z "$MQTT_WS_PORT" ]]; then
	export MQTT_WS_PORT=8083
fi

if [[ -z "$FRAPPE_PY" ]]; then
    export FRAPPE_PY=0.0.0.0
fi

if [[ -z "$FRAPPE_PY_PORT" ]]; then
    export FRAPPE_PY_PORT=8000
fi

if [[ -z "$API_HOST" ]]; then
    export API_HOST=0.0.0.0
fi

if [[ -z "$API_PORT" ]]; then
    export API_PORT=8881
fi

envsubst '${MQTT_HOST}
    ${MQTT_WS_PORT}
    ${FRAPPE_PY}
    ${FRAPPE_PY_PORT}
    ${API_HOST}
    ${API_PORT}
    ${SITE_NAME}
    ${CLOUD_SITE_NAME}' \
    < /etc/nginx/conf.d/default.conf.template > /etc/nginx/conf.d/default.conf

echo "Waiting for frappe-python to be available on $FRAPPE_PY port $FRAPPE_PY_PORT"
timeout 10 bash -c 'until printf "" 2>>/dev/null >>/dev/tcp/$0/$1; do sleep 1; done' $FRAPPE_PY $FRAPPE_PY_PORT
echo "Frappe-python available on $FRAPPE_PY port $FRAPPE_PY_PORT"

exec "$@"

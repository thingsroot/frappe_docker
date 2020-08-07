#!/bin/bash

function configureEnv() {
	if [ ! -f /var/www/nodeServer/config/productionConfig.js ]; then

		if [[ -z "$INFLUXDB_HOST" ]]; then
			echo "INFLUXDB_HOST is not set"
			exit 1
		fi

		if [[ -z "$REDIS_HOST" ]]; then
			echo "REDIS_HOST is not set"
			exit 1
		fi

		if [[ -z "$FRAPPE_PY" ]]; then
			echo "FRAPPE_PY is not set"
			exit 1
		fi

		if [[ -z "$INFLUXDB_PORT" ]]; then
			export INFLUXDB_PORT=8086
		fi

		if [[ -z "$INFLUXDB_USER" ]]; then
			export INFLUXDB_USER="root"
		fi

		if [[ -z "$INFLUXDB_PASSWORD" ]]; then
			export INFLUXDB_PASSWORD="root"
		fi

		if [[ -z "$REDIS_PORT" ]]; then
			export REDIS_PORT=6379
		fi

		if [[ -z "$FRAPPE_PY_PORT" ]]; then
			export FRAPPE_PY_PORT=8000
		fi

		envsubst '${REDIS_HOST}
		${REDIS_PORT}
		${INFLUXDB_HOST}
		${INFLUXDB_PORT}
		${INFLUXDB_USER}
		${INFLUXDB_PASSWORD}
		${FRAPPE_PY}
		${FRAPPE_PY_PORT}' < /var/www/nodeServer/config/productionConfig.js.template > /var/www/nodeServer/config/productionConfig.js
	fi
}

if [ "$1" = 'start' ]; then
  configureEnv

  echo "Waiting for frappe-python to be available on $FRAPPE_PY port $FRAPPE_PY_PORT"
  timeout 10 bash -c 'until printf "" 2>>/dev/null >>/dev/tcp/$0/$1; do sleep 1; done' $FRAPPE_PY $FRAPPE_PY_PORT
  echo "Frappe-python available on $FRAPPE_PY port $FRAPPE_PY_PORT"

  cd /var/www/nodeServer
  node /var/www/nodeServer/bin/www.js
fi

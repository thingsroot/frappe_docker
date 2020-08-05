#!/bin/bash

function configureEnv() {
	if [ ! -f /home/frappe/services/iot_mqtt_clients/config.ini -o -f /home/frappe/services/iot_cloud_apps/config.ini ]; then

		if [[ -z "$MQTT_HOST" ]]; then
			echo "MQTT_HOST is not set"
			exit 1
		fi

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

		if [[ -z "$MQTT_PORT" ]]; then
			export MQTT_PORT=3306
		fi

		if [[ -z "$MQTT_KEEPALIVE" ]]; then
			export MQTT_KEEPALIVE=60
		fi

		if [[ -z "$MQTT_USER" ]]; then
			export MQTT_USER="root"
		fi

		if [[ -z "$MQTT_PASSWORD" ]]; then
			export MQTT_PASSWORD="1234567890"
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

		if [[ -z "$FRAPPE_AUTH_CODE" ]]; then
			export FRAPPE_AUTH_CODE="1234567890"
		fi

		export REDIS_URL="redis://${REDIS_HOST}:${REDIS_HOST}"
		export FRAPPE_URL="http://${FRAPPE_PY_HOST}:${FRAPPE_PY_HOST}"

		envsubst '${MQTT_HOST}
		${MQTT_PORT}
		${MQTT_KEEPALIVE}
		${MQTT_USER}
		${MQTT_PASSWORD}
		${INFLUXDB_HOST}
		${INFLUXDB_PORT}
		${INFLUXDB_USER}
		${INFLUXDB_PASSWORD}
		${REDIS_URL}
		${FRAPPE_URL}
		${FRAPPE_AUTH_CODE}' < /home/frappe/services/iot_mqtt_clients/config.ini.template > /home/frappe/services/iot_mqtt_clients/config.ini

		envsubst '${MQTT_HOST}
		${MQTT_PORT}
		${MQTT_KEEPALIVE}
		${MQTT_USER}
		${MQTT_PASSWORD}
		${INFLUXDB_HOST}
		${INFLUXDB_PORT}
		${INFLUXDB_USER}
		${INFLUXDB_PASSWORD}
		${REDIS_URL}
		${FRAPPE_URL}
		${FRAPPE_AUTH_CODE}' < /home/frappe/services/iot_cloud_apps/config.ini.template > /home/frappe/services/iot_cloud_apps/config.ini
	fi
}

# Allow user process to create files in logs directory
chown -R frappe:frappe /var/log/supervisor/iot_mqtt_clients
chown -R frappe:frappe /var/log/supervisor/iot_cloud_apps

if [ "$1" = 'start' ]; then
  configureEnv

  if [ -f /etc/default/supervisor ]; then
	  source /etc/default/supervisor
  fi

  supervisord --nodaemon -c /etc/supervisor/supervisord.conf
fi

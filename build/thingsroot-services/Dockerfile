FROM bitnami/python:3.7-prod

RUN useradd -ms /bin/bash frappe

ARG GIT_BRANCH=master
ENV PYTHONUNBUFFERED 1

# Install dependencies
WORKDIR /home/frappe/services
RUN install_packages \
    git \
	supervisor \
    && apt-get purge -y wget && apt-get autoremove -y

# Create frappe-bench directories
RUN mkdir -p /home/frappe/services/logs

# Setup iot_mqtt_clients 
RUN git clone --depth 1 -o upstream https://github.com/symgrid/iot_mqtt_clients --branch ${GIT_BRANCH} \
    && pip3 install --no-cache-dir -r iot_mqtt_clients/requirements.txt \
	&& ln -s /home/frappe/services/iot_mqtt_clients /usr/iot_mqtt_clients \
	&& ln -s /home/frappe/services/iot_mqtt_clients/supervisor.conf /etc/supervisor/conf.d/iot_mqtt_clients.conf \
	&& rm -rf /home/frappe/services/iot_mqtt_clients/logs \
	&& ln -s /home/frappe/services/logs/iot_mqtt_clients /home/frappe/services/iot_mqtt_clients/logs \
	&& rm -f /home/frappe/services/iot_mqtt_clients/config.ini

RUN git clone --depth 1 -o upstream https://github.com/symgrid/iot_cloud_apps --branch ${GIT_BRANCH} \
    && pip3 install --no-cache-dir -r iot_cloud_apps/requirements.txt \
	&& ln -s /home/frappe/services/iot_cloud_apps /usr/iot_cloud_apps \
	&& ln -s /home/frappe/services/iot_cloud_apps/supervisor.conf /etc/supervisor/conf.d/iot_cloud_apps.conf \
	&& mkdir -p /home/frappe/services/logs/iot_cloud_apps/iot/logs \
	&& mkdir -p /home/frappe/services/logs/iot_cloud_apps/iot_bridge/logs \
	&& mkdir -p /home/frappe/services/logs/iot_cloud_apps/iot_ws_api/logs \
	&& rm -rf /home/frappe/services/iot_cloud_apps/iot/logs \
	&& rm -rf /home/frappe/services/iot_cloud_apps/iot_bridge/logs \
	&& rm -rf /home/frappe/services/iot_cloud_apps/iot_ws_api/logs \
	&& ln -s /home/frappe/services/logs/iot_cloud_apps/iot/logs /home/frappe/services/iot_cloud_apps/iot/logs \
	&& ln -s /home/frappe/services/logs/iot_cloud_apps/iot_bridge/logs /home/frappe/services/iot_cloud_apps/iot_bridge/logs \
	&& ln -s /home/frappe/services/logs/iot_cloud_apps/iot_ws_api/logs /home/frappe/services/iot_cloud_apps/iot_ws_api/logs \
	&& rm -f /home/frappe/services/iot_cloud_apps/config.ini

# Copy scripts and templates
COPY build/thingsroot-services/iot_mqtt_clients.config.ini.template /home/frappe/services/iot_mqtt_clients/config.ini.template
COPY build/thingsroot-services/iot_cloud_apps.config.ini.template /home/frappe/services/iot_cloud_apps/config.ini.template

# Setup docker-entrypoint
COPY build/thingsroot-services/docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh

# Set ownership of sites directory
RUN chown -R frappe:frappe /home/frappe/services

VOLUME [ "/home/frappe/services/logs" ]

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["start"]

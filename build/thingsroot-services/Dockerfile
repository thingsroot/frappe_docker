FROM bitnami/python:3.7-prod

RUN useradd -ms /bin/bash frappe

ARG GIT_BRANCH=master
ENV PYTHONUNBUFFERED 1

# Install dependencies
WORKDIR /home/frappe/services
RUN install_packages \
    git \
	gettext-base \
	supervisor \
    && apt-get autoremove -y

# Create frappe-bench directories
RUN mkdir -p /var/log/supervisor \
	&& mkdir -p /var/log/supervisor/iot_mqtt_clients \
	&& touch /var/log/supervisor/iot_mqtt_clients/__keepme \
	&& mkdir -p /var/log/supervisor/iot_cloud_apps/iot \
	&& mkdir -p /var/log/supervisor/iot_cloud_apps/iot_bridge \
	&& mkdir -p /var/log/supervisor/iot_cloud_apps/iot_ws_api

# Setup iot_mqtt_clients 
RUN git clone --depth 1 -o upstream https://github.com/symgrid/iot_mqtt_clients --branch ${GIT_BRANCH} \
    && pip3 install --no-cache-dir -r iot_mqtt_clients/requirements.txt \
	&& ln -s /home/frappe/services/iot_mqtt_clients/supervisor.conf /etc/supervisor/conf.d/iot_mqtt_clients.conf \
	&& rm -rf /home/frappe/services/iot_mqtt_clients/logs \
	&& ln -s /var/log/supervisor/iot_mqtt_clients /home/frappe/services/iot_mqtt_clients/logs \
	&& rm -f /home/frappe/services/iot_mqtt_clients/config.ini \
	&& ln -s /home/frappe/services/iot_mqtt_clients /usr/iot_mqtt_clients

RUN git clone --depth 1 -o upstream https://github.com/symgrid/iot_cloud_apps --branch ${GIT_BRANCH} \
    && pip3 install --no-cache-dir -r iot_cloud_apps/requirements.txt \
	&& ln -s /home/frappe/services/iot_cloud_apps/supervisor.conf /etc/supervisor/conf.d/iot_cloud_apps.conf \
	&& rm -rf /home/frappe/services/iot_cloud_apps/iot/logs \
	&& rm -rf /home/frappe/services/iot_cloud_apps/iot_bridge/logs \
	&& rm -rf /home/frappe/services/iot_cloud_apps/iot_ws_api/logs \
	&& ln -s /var/log/supervisor/iot_cloud_apps/iot /home/frappe/services/iot_cloud_apps/iot/logs \
	&& ln -s /var/log/supervisor/iot_cloud_apps/iot_bridge /home/frappe/services/iot_cloud_apps/iot_bridge/logs \
	&& ln -s /var/log/supervisor/iot_cloud_apps/iot_ws_api /home/frappe/services/iot_cloud_apps/iot_ws_api/logs \
	&& rm -f /home/frappe/services/iot_cloud_apps/config.ini \
	&& ln -s /home/frappe/services/iot_cloud_apps /usr/iot_cloud_apps

# Copy scripts and templates
COPY build/thingsroot-services/iot_mqtt_clients.config.ini.template /home/frappe/services/iot_mqtt_clients/config.ini.template
COPY build/thingsroot-services/iot_cloud_apps.config.ini.template /home/frappe/services/iot_cloud_apps/config.ini.template

# Setup docker-entrypoint
COPY build/thingsroot-services/docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh

# Set ownership of sites directory
RUN chown -R frappe:frappe /var/log/supervisor/iot_mqtt_clients
RUN chown -R frappe:frappe /var/log/supervisor/iot_cloud_apps

VOLUME [ "/var/log/supervisor" ]

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["start"]

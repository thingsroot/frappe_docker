ARG GIT_BRANCH=master
ARG FRAPPE_BRANCH=version-12
FROM node:buster-slim

ARG GIT_BRANCH
ARG FRAPPE_BRANCH
COPY build/thingsroot-nginx/install_app.sh /install_app
RUN chmod +x /install_app && \
  apt-get update -y && \
  apt-get install build-essential git python2 -y && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*

RUN /install_app ${GIT_BRANCH} ${FRAPPE_BRANCH}

FROM frappe/frappe-nginx:${FRAPPE_BRANCH}

COPY --from=0 /home/frappe/frappe-bench/sites/ /var/www/html/
COPY --from=0 /rsync /rsync
RUN echo "wechat" >> /var/www/html/apps.txt
RUN echo "cloud" >> /var/www/html/apps.txt
RUN echo "conf_center" >> /var/www/html/apps.txt
RUN echo "app_center" >> /var/www/html/apps.txt
RUN echo "iot" >> /var/www/html/apps.txt
RUN echo "ioe_api" >> /var/www/html/apps.txt
RUN echo "iot_chan" >> /var/www/html/apps.txt

VOLUME [ "/assets" ]

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]

ARG NODE_IMAGE_TAG=12-prod
FROM bitnami/node:${NODE_IMAGE_TAG}

WORKDIR /var/www

RUN mkdir -p /var/www

RUN install_packages git && apt-get autoremove -y

ARG GIT_BRANCH=master

RUN git clone --depth 1 https://github.com/thingsroot/nodeServer --branch $GIT_BRANCH

RUN cd nodeServer \
	&& npm install

RUN node --version \
    && npm --version

RUN rm /var/www/nodeServer/config/productionConfig.js

COPY build/thingsroot-node-api/productionConfig.js.template /var/www/nodeServer/config/productionConfig.js.template

# Setup docker-entrypoint
COPY build/thingsroot-node-api/docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["start"]

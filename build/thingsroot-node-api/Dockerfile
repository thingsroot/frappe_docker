FROM node:buster-slim

WORKDIR /var/www

RUN mkdir -p /var/www

RUN apt-get update -y && \
	apt-get install git gettext-base -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

ARG GIT_BRANCH=master

RUN git clone --depth 1 https://github.com/thingsroot/nodeServer --branch $GIT_BRANCH

RUN cd nodeServer \
	&& npm install

RUN node --version \
    && npm --version

RUN rm /var/www/nodeServer/config/productionConfig.js
RUN sed -i -e 's/127.0.0.1/0.0.0.0/' /var/www/nodeServer/bin/www.js

COPY build/thingsroot-node-api/productionConfig.js.template /var/www/nodeServer/config/productionConfig.js.template

# Setup docker-entrypoint
COPY build/thingsroot-node-api/docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh

EXPOSE 8881

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["start"]

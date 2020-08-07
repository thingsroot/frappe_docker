ARG NODE_IMAGE_TAG=12-prod
FROM bitnami/node:${NODE_IMAGE_TAG}

WORKDIR /var/www/

RUN mkdir -p /var/www

RUN install_packages git

ARG GIT_BRANCH=master

RUN git clone --depth 1 https://github.com/thingsroot/ReactProject --branch $GIT_BRANCH

COPY build/thingsroot-web/assets_path_index.js /var/www/ReactProject/src/assets/path/index.js

RUN mkdir ~/.npm-global \
	&& npm config set prefix '~/.npm-global' \
	&& echo "export PATH=~/.npm-global/bin:$PATH" >> /etc/profile

RUN cd ReactProject \
	&& export PATH=~/.npm-global/bin:$PATH \
	&& npm install \
	&& npm run build

RUN node --version \
    && npm --version

FROM nginx:latest
COPY --from=0 /var/www/ReactProject/build/* /var/www/html/
COPY build/thingsroot-web/nginx-default.conf.template /etc/nginx/conf.d/default.conf.template
COPY build/thingsroot-web/docker-entrypoint.sh /usr/local/bin/

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]

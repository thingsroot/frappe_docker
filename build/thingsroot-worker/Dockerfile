ARG GIT_BRANCH=master
ARG FRAPPE_BRANCH=version-12
FROM frappe/frappe-worker:${FRAPPE_BRANCH}

ARG GIT_BRANCH
COPY build/common/worker/install_app.sh /usr/local/bin/install_app
RUN install_app wechat https://github.com/srdgame/frappe_wechat ${GIT_BRANCH}
RUN install_app cloud https://github.com/srdgame/frappe_cloud ${GIT_BRANCH}
RUN install_app conf_center https://github.com/srdgame/frappe_conf_center ${GIT_BRANCH}
RUN install_app app_center https://github.com/srdgame/frappe_app_center ${GIT_BRANCH}
RUN install_app iot https://github.com/srdgame/frappe_iot ${GIT_BRANCH}
RUN install_app ioe_api https://github.com/srdgame/frappe_ioe_api ${GIT_BRANCH}

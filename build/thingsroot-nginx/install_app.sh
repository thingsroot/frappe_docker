#!/bin/bash

APP_BRANCH=${1}
FRAPPE_BRANCH=${2}

[ "${APP_BRANCH}" ] && BRANCH="-b ${APP_BRANCH}"
[ "${FRAPPE_BRANCH}" ] && BRANCH_FRP="-b ${FRAPPE_BRANCH}"

mkdir -p /home/frappe/frappe-bench/sites/assets
cd /home/frappe/frappe-bench
echo -e "frappe\nwechat\ncloud\nconf_center\napp_center\niot\nioe_api\niot_chan" > /home/frappe/frappe-bench/sites/apps.txt

mkdir -p apps
cd apps
git clone --depth 1 https://github.com/frappe/frappe ${BRANCH_FRP}
git clone --depth 1 https://github.com/srdgame/frappe_wechat wechat ${BRANCH}
git clone --depth 1 https://github.com/srdgame/frappe_cloud cloud ${BRANCH}
git clone --depth 1 https://github.com/srdgame/frappe_conf_center conf_center ${BRANCH}
git clone --depth 1 https://github.com/srdgame/frappe_app_center app_center ${BRANCH}
git clone --depth 1 https://github.com/srdgame/frappe_iot iot ${BRANCH}
git clone --depth 1 https://github.com/srdgame/frappe_ioe_api ioe_api ${BRANCH}
git clone --depth 1 https://github.com/srdgame/frappe_iot_chan iot_chan ${BRANCH}


echo "Install frappe NodeJS dependencies . . ."
cd /home/frappe/frappe-bench/apps/frappe
yarn
echo "Build browser assets . . ."
cd /home/frappe/frappe-bench/apps/frappe
yarn production --app wechat
yarn production --app cloud
yarn production --app conf_center
yarn production --app app_center
yarn production --app iot
yarn production --app ioe_api
yarn production --app iot_chan
echo "Install frappe NodeJS production dependencies . . ."
cd /home/frappe/frappe-bench/apps/frappe
yarn install --production=true

mkdir -p /home/frappe/frappe-bench/sites/assets/cloud
cp -R /home/frappe/frappe-bench/apps/cloud/cloud/public/* /home/frappe/frappe-bench/sites/assets/cloud
mkdir -p /home/frappe/frappe-bench/sites/assets/app_center
cp -R /home/frappe/frappe-bench/apps/app_center/app_center/public/* /home/frappe/frappe-bench/sites/assets/app_center
mkdir -p /home/frappe/frappe-bench/sites/assets/iot/images
mkdir -p /home/frappe/frappe-bench/sites/assets/iot/js
cp -R /home/frappe/frappe-bench/apps/iot/iot/public/images /home/frappe/frappe-bench/sites/assets/iot/images
cp /home/frappe/frappe-bench/apps/iot/iot/public/js/setup_wizard.js /home/frappe/frappe-bench/sites/assets/iot/js/

# Add frappe and all the apps available under in frappe-bench here
echo "rsync -a --delete /var/www/html/assets/frappe /assets" > /rsync
echo "rsync -a --delete /var/www/html/assets/cloud /assets" >> /rsync
echo "rsync -a --delete /var/www/html/assets/app_center /assets" >> /rsync
echo "rsync -a --delete /var/www/html/assets/iot /assets" >> /rsync
chmod +x /rsync

rm /home/frappe/frappe-bench/sites/apps.txt

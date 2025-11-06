#!/usr/bin/bash

cd /tmp

# if it is not a sarus-suite-deploy-build container, update it
PACKAGES_FILE="run.packages"
if [ ! -f /etc/sarus-suite-deploy.build ] && [ -f "${PACKAGES_FILE}" ]
then
  PACKAGES=$(cat ${PACKAGES_FILE} | paste -s -d" ")
  zypper install -y ${PACKAGES}
fi

./conmon --version

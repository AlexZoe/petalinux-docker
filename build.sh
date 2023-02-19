#!/bin/bash

USER_ID=$(id -u) PETA_RUN_FILE=petalinux-v2019.2-final-installer.run docker compose build

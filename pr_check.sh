#!/bin/bash

# --------------------------------------------
# Pre-commit checks
# --------------------------------------------
export APP_NAME="xjoin"  # name of app-sre "application" folder this component lives in
export IMAGE="quay.io/cloudservices/xjoin-validation"
export LC_ALL=en_US.utf-8
export LANG=en_US.utf-8
export APP_ROOT=$(pwd)
export WORKSPACE=${WORKSPACE:-$APP_ROOT}  # if running in jenkins, use the build's workspace
export IMAGE_TAG=$(git rev-parse --short=7 HEAD)
export GIT_COMMIT=$(git rev-parse HEAD)
export QUAY_EXPIRE_TIME="3d"
cat /etc/redhat-release

# --------------------------------------------
# Options that must be configured by app owner
# --------------------------------------------
COMPONENT_NAME="xjoin-validation"  # name of app-sre "resourceTemplate" in deploy.yaml for this component

#IQE_PLUGINS="xjoin-validation"
#IQE_MARKER_EXPRESSION="smoke"
#IQE_FILTER_EXPRESSION=""
#IQE_CJI_TIMEOUT="30m"

# ---------------------------
# We'll take it from here ...
# ---------------------------

# Get bonfire helper scripts
CICD_URL=https://raw.githubusercontent.com/RedHatInsights/bonfire/master/cicd
curl -s $CICD_URL/bootstrap.sh > .cicd_bootstrap.sh && source .cicd_bootstrap.sh

# build the PR commit image
source $CICD_ROOT/build.sh

# Run the app unit tests
source $APP_ROOT/unit_test.sh

# Run IQE tests
#source $CICD_ROOT/deploy_ephemeral_env.sh
#source $CICD_ROOT/cji_smoke_test.sh
#source $CICD_ROOT/post_test_results.sh
#!/bin/bash

echo "##### "
echo "##### ci/deploy.sh"
echo "#####"


function init {
  cd ..
  SITE_PATH=$(readJsonProp "config.json" "sitePath")
  cd ..
  export IONIC_DIR=$PWD
  SITE_DIR=$IONIC_DIR/$SITE_PATH
}

function run {

  VERSION=$(readJsonProp "package.json" "version")

  # process new docs
  ./node_modules/.bin/gulp docs

  # CD in to the site dir to commit updated docs
  cd $SITE_DIR

  CHANGES=$(git status --porcelain)

  # if no changes, don't commit
  if [[ "$CHANGES" == "" ]]; then
    echo "-- No changes detected for the following commit, docs not updated."
    echo "https://github.com/driftyco/$CIRCLE_PROJECT_REPONAME/commit/$CIRCLE_SHA1"
  else
    git config --global user.email "hi@ionicframework.com"
    git config --global user.name "Ionitron"
    git add -A
    git commit -am "Automated build of native docs driftyco/$CIRCLE_PROJECT_REPONAME@$CIRCLE_SHA1"
    git push origin master

    echo "-- Updated docs for $VERSION_NAME succesfully!"
  fi
}

source $(dirname $0)/../utils.inc.sh

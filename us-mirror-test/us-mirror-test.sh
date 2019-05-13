#!/bin/bash

set -o xtrace

MAVEN_REPO=/tmp/testrepo
clean_repo() {
  mkdir -p $MAVEN_REPO/../backup
  [ -e $MAVEN_REPO/org/apache/maven ] && mv $MAVEN_REPO/org/apache/maven $MAVEN_REPO/../backup
  [ -e $MAVEN_REPO/org/codehaus ] && mv $MAVEN_REPO/org/codehaus $MAVEN_REPO/../backup
  echo deleting contents under MAVEN_REPO = $MAVEN_REPO
  rm -r $MAVEN_REPO

  mkdir -p $MAVEN_REPO
  [ -e $MAVEN_REPO/org/apache/maven ] && \
    mkdir -p $MAVEN_REPO/org/apache/ && cp -r $MAVEN_REPO/../backup/maven $MAVEN_REPO/org/apache/
  [ -e $MAVEN_REPO/org/codehaus ] && cp -r $MAVEN_REPO/../backup/codehaus $MAVEN_REPO/org/
}

if [ ! -e 'wso2-maven-test-repo' ]; then
  git clone https://github.com/kasunbg/wso2-maven-test-repo.git
  cd wso2-maven-test-repo
else
  echo existing clone found at wso2-maven-test-repo. Doing a git pull instead.
  cd wso2-maven-test-repo
  git pull -v
fi

clean_repo
set -e
echo installing carbon-parent with us-nexus-mirror settings.
pwd
cd us-mirror-test
../mvnw install:install-file -Dfile=wso2-5.pom -DpomFile=wso2-5.pom -Dmaven.repo.local=$MAVEN_REPO

cd ../ 
./mvnw clean install -Dmaven.repo.local=$MAVEN_REPO

echo completed successfully.

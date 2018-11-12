#!/bin/bash

set -eu

REPONAME=$1
PERSONAL_ACCESS_TOKEN=$2

push() {
  echo "Packaging ${TAR}"
  cp "${TAR}" "./docs/${TAR}"
  if [ -e ${TAR}.prov ]; then
    cp "${TAR}.prov" "./docs/${TAR}.prov"
  fi
  helm repo index ./docs
  git add docs/$TAR ./docs/index.yaml
  git commit -m "Auto-commit ${TAR}"
  # git push origin master
  git push -q https://${PERSONAL_ACCESS_TOKEN}@github.com/giantswarm/${REPONAME}.git master
  echo "Successfully pushed ${TAR} to GitHub"
}

# Install and package chart
curl https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get | bash
CHART=$(helm package --save=false helm/kubernetes-test-app-chart | tr "/" " " | awk '{print $NF}')
# mkdir -p /home/circleci/.helm/plugins
# helm plugin install https://github.com/technosophos/helm-github


# Set up git
git config credential.helper 'cache --timeout=120'
git config user.email "dev@giantswarm.io"
git config user.name "Taylor Bot"

# Push to github
push()

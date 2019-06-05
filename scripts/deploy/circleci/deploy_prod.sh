#!/usr/bin/env bash
# This script deploys the built site to the prod-pages branch of the same repo.

# Customize these variables for your specific implementation.
###################################
# This is the Github organisation or username of your fork. For example, if
# your fork is located at https://github.com/xyz/open-sdg-site-starter, then
# you should put "xyz" here. Changing this is required.
GH_ORG_PROD="sustainabledevelopment-Namibia"
# These variables only control the name/email on the automated Git commits.
# Changing this is optional.
GH_NAME="CircleCI"
GH_EMAIL="mhilongwa@nsa.org.na"
###################################

# There is probably no need to modify anything below this point.
git config --global user.email "$GH_EMAIL"
git config --global user.name "$GH_NAME"

# CircleCI will identify the SSH key with a "Host" of gh-prod. In order to tell
# Git to use this key, we need to hack the SSH key:
sed -i -e 's/Host gh-prod/Host gh-prod\n  HostName github.com/g' ~/.ssh/config
git clone git@gh-prod:$GH_ORG_PROD/$CIRCLE_PROJECT_REPONAME.git out

cd out
git checkout prod-pages || git checkout --orphan prod-pages
git rm -rfq .
cd ..

# The fully built site is already available at ~/repo/_site.
cp -a ~/repo/_site/. out/.

mkdir -p out/.circleci && cp -a .circleci/. out/.circleci/.
cd out

git add -A
git commit -m "Automated production build: ${CIRCLE_SHA1}" --allow-empty

git push origin prod-pages

#!/bin/bash
printf -- "//registry.npmjs.org/:_authToken=\${NPM_PUBLISH_TOKEN}" > .npmrc
npm config set '//registry.npmjs.org/:_authToken' "${NPM_PUBLISH_TOKEN}";

git checkout ${TRAVIS_BRANCH};
git reset --hard ${TRAVIS_COMMIT};
git remote set-url origin ${GITHUB_URL_W_AUTH};
npm config set '//registry.npmjs.org/:_authToken' "${NPM_PUBLISH_TOKEN}";
npm run build;
if [ "${TRAVIS_PULL_REQUEST}" = "false" ]; then
if [ -z "${TRAVIS_COMMIT_MESSAGE##*"[major release]"*}" ]; then
    LERNA_CD_VERSION='major';
elif [ -z "${TRAVIS_COMMIT_MESSAGE##*"[minor release]"*}" ]; then
    LERNA_CD_VERSION='minor';
else
    LERNA_CD_VERSION='patch';
fi;
lerna publish --yes --cd-version ${LERNA_CD_VERSION};
fi;
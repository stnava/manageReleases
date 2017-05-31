REPO=$1
GIT_TAG=latest
GITHUB_TOKEN=`whoami`
git push origin :$GIT_TAG
git tag -d $GIT_TAG
git tag $GIT_TAG -a -m 'latest/nightly version, may be unstable'
git push -q https://${GITHUB_TOKEN}@github.com/stnava/${REPO} --tags

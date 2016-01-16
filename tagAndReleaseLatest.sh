num=0
REPO=ITKR
cd ~/code/${REPO}
alltags=`git tag`
GIT_TAG=latest
for t in $alltags  ; do
  if [[ $t == $GIT_TAG ]] ; then
    if [ "$num" -ge 1 ]; then
        break
    fi
    if [[ ${#doRelease} -gt 0  ]] ; then
      if [[ ${doRelease} == 0  ]] ; then
        git push origin :$t
        git tag -d $t
        echo "Removed $t"
      fi
    fi
  fi
  num=`expr $num + 1`
done
echo $num releases
doRelease=$1
if [[ ${#doRelease} -gt 0  ]] ; then
  if [[ ${doRelease} == 1  ]] ; then
    git tag $GIT_TAG -a -m 'latest/nightly version, may be unstable'
    git push -q https://${GH_TOKEN}@github.com/stnava/${REPO} --tags
  fi
fi

if [[ ${#doRelease} -gt 0  ]] ; then
  if [[ ${doRelease} == 2  ]] ; then # fix with github-release
  github-release edit \
    --user stnava \
    --repo ${REPO} \
    --tag $GIT_TAG \
    --name "Latest/nightly release" \
    --description "The .tgz is the OSX binary and x86_64-pc-linux-gnu.tar.gz is the linux (via travis) binary.  You can see how these are created by looking at the travis.yml file."
  fi
fi

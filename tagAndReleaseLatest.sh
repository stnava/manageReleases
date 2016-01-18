num=0
REPO=$1
doRelease=$2
GIT_TAG=latest
if [[ ${#3} -gt 0 ]] ; then
  GIT_TAG=$3
fi
if [[ ${#REPO} -eq 0  ]] ; then
  echo usage:
  echo $0 RepositoryName option GIT_TAG
  echo GIT_TAG defaults to 'latest'
  echo where option 0 indicates to delete GIT_TAG
  echo where option 1 indicates to create and push GIT_TAG
  echo where option 2 indicates to modify GIT_TAG notes
  exit
fi
cd ~/code/${REPO}
alltags=`git tag`
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
if [[ ${#doRelease} -gt 0  ]] ; then
  if [[ ${doRelease} == 1  ]] ; then
    git tag $GIT_TAG -a -m 'latest/nightly version, may be unstable'
    git push -q https://${GITHUB_TOKEN}@github.com/stnava/${REPO} --tags
  fi
fi

if [[ ${#doRelease} -gt 0  ]] ; then
  if [[ ${doRelease} == 2  ]] ; then # fix with github-release
    # add manual
    export reponame=${REPO}
    rm ${REPO}.pdf
    Rscript -e ' path <- find.package( Sys.getenv( c("reponame")));system(paste(shQuote(file.path(R.home("bin"), "R")),  "CMD", "Rd2pdf", shQuote(path)))'
    github-release upload \
      --user stnava \
      --repo ${REPO} \
      --tag $GIT_TAG \
      --file ${REPO}.pdf \
      -n ${REPO}-manual.pdf \
      -l "R style manual"
    # add vignettes
    Rscript -e 'vgnnames=Sys.glob("vignettes/*Rmd"); for (x in vgnnames ) rmarkdown::render( x )'
    for x in vignettes/*html; do
      github-release upload \
        --user stnava \
        --repo ${REPO} \
        --tag $GIT_TAG \
        --file $x \
        -n $x
    done
    github-release edit \
      --user stnava \
      --repo ${REPO} \
      --tag $GIT_TAG \
      --name "Latest/nightly release" \
      --description "The .tgz is the OSX binary and x86_64-pc-linux-gnu.tar.gz is the linux (via travis) binary.  You can see how these are created by looking at the travis.yml file."
  fi
fi

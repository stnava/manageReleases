# run this on each repo ITKR and ANTsR
repo=$1
if [[ ${#repo} -eq 0 ]] ; then
  if [[ -s ~/code/${repo} ]] ; then
    bash ./tagAndReleaseLatest.sh ${repo} 0 latest
    bash ./tagAndReleaseLatest.sh ${repo} 1 latest
    # wait for builds to finish and deploy
    sleep 3600
    bash ./tagAndReleaseLatest.sh ${repo} 2 latest
  fi
fi

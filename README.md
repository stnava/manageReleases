# manageReleases

Utilities for managing github releases and versions.

A basic work flow might be:

```
bash ./tagAndReleaseLatest.sh ITKR 0 latest
bash ./tagAndReleaseLatest.sh ITKR 1 latest
# wait for builds to finish and deploy
sleep 3600
bash ./tagAndReleaseLatest.sh ITKR 2 latest
# now do ANTsR
bash ./tagAndReleaseLatest.sh ANTsR 0 latest
bash ./tagAndReleaseLatest.sh ANTsR 1 latest
# wait for builds to finish and deploy
sleep 3600
bash ./tagAndReleaseLatest.sh ANTsR 2 latest
```

This should produce binary packages on github for both ITKR and ANTsR, under
the name of `latest`.

dependencies include:

* [go](https://golang.org)

* [github-release](https://github.com/aktau/github-release)

and also github and travis projects.

these are simple scripts that are intended to automate code release.

*see these sites for more info*

* [travis releases and encryption of GH_TOKEN](https://rmflight.github.io/posts/2014/11/travis_ci_gh_pages.html)

* [travis deployment](https://docs.travis-ci.com/user/deployment/)

* [deploy gh-pages](https://iamstarkov.com/deploy-gh-pages-from-travis/)

* [interesting idea for automating github releases](http://stackoverflow.com/questions/28217556/travis-ci-auto-tag-build-for-github-release)

* [more ideas](https://github.com/travis-ci/travis.rb/issues/199)

...

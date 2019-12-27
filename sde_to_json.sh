#!/bin/bash

wget -O page https://developers.eveonline.com/resource/resources

currentrev=$(grep "https.*sde.*zip" page | awk -F '-' '{print $2}')
echo 'Current resources revision :' $currentrev
lastrev=$(git describe --abbrev=0 --tags)
if git rev-parse $currentrev >/dev/null 2>&1
then
    if [[ $lastrev == $currentrev ]]
    then
        echo "Already lastest resources"
        exit
    fi
fi
echo 'Latest resources revision was :' $lastrev
echo 'Building resources files for new revision' $currentrev
python3 toJSON.py
echo "export gittag=$currentrev" > gittag

# config
git config --global user.email "nobody@nobody.org"
git config --global user.name "Travis CI"

git init
git add .
git commit -m "Deploy to Github Pages"
git push --force "https://${GH_TOKEN}@github.com/evetrade_resources.git" master:gh-pages


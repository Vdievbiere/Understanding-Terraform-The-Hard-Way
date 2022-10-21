#!/bin/sh

echo "Add files and do local commit"
git add .

echo "checking status"
git status

git commit -am "Welcome to Kojitechs"

echo "Pushing to Gitlab Repository"
git push

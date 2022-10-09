#!/usr/bin/env bash

echo 'Pulling'
git pull

echo "Generating posts"
hexo g

echo 'Adding to git'
git add -A
echo 'Added'
echo 'Committing'
git commit -m update
echo 'Committed'
echo 'Pushing'
git push
echo 'Finished'
sleep(2);
echo "Exit"
exit(0);
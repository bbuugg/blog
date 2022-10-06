#!/usr/bin/env bash

hexo g

git add -A
git commit -m update
git push
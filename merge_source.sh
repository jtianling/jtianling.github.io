#!/bin/bash

git merge source
git filter-branch -f --subdirectory-filter build -- master

touch README.md
echo "This is my personal blog buit using [Metalsmith](http://www.metalsmith.io)" > README.md

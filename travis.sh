#!/bin/bash -e

brew update && brew upgrade --all

if [ "$TRAVIS_PULL_REQUEST" ==  "false" ]; then
    export changed_files=`git diff-tree --no-commit-id --name-only -r $TRAVIS_COMMIT | grep .rb `
else
    git fetch origin pull/${TRAVIS_PULL_REQUEST}/head:travis-pr-${TRAVIS_PULL_REQUEST}
    git checkout travis-pr-${TRAVIS_PULL_REQUEST}
    echo "commit: $TRAVIS_COMMIT"
    echo "log: $(git log -1)"
    export changed_files=`git diff-tree --no-commit-id --name-only HEAD^ HEAD | grep .rb`
fi

echo $changed_files
if [ -z "$changed_files" ]
then
    echo "Nothing to test"
    exit 0
fi

for file in $changed_files
do
    # Dump output of building dependencies to log file
    brew reinstall $(brew deps $file)
    # Explicitly print the verbose output of test-bot
    brew test-bot $file -v
done

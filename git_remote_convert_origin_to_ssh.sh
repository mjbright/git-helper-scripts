#!/bin/bash

echo "git remote entries before change:"
git remote -v

# # replace origin/http? entry with origin/ssh entry:
# REPLACE_ORIGIN=1
# REPLACE_ORIGIN=0
# If no NEW_REMOTE is given (-add <remotename>) then replace origin:
NEW_REMOTE=""


die() {
    echo "$0: die - $*" >&2
    exit 1
}

press() {
    echo "$*"
    echo "Press <return> to continue [q to quit]"
    read _DUMMY
    [ "$_DUMMY" = "q" ] && exit 0
    [ "$_DUMMY" = "Q" ] && exit 0
}

while [ ! -z "$1" ];do
    case $1 in
        -add) shift; NEW_REMOTE=$1;;
        *) die "Unknown option <$1>";;
    esac
    shift
done

#NEW_ENTRY=$(git remote -v | awk '/^origin.*http.*\(fetch\)/ { print $2; }' | sed -e 's/https\?:\/\/.*github.com/ssh\tssh:\/\/git\@github.com/')
NEW_URL=$(git remote -v | awk '/^origin.*http.*\(fetch\)/ { print $2; }' | sed -e 's/https\?:\/\/.*github.com/ssh:\/\/git\@github.com/')

[ -z "$NEW_URL" ] && die "Failed to determine NEW_URL to use"
echo "NEW_URL=<<$NEW_URL>>"


echo
if [ -z "$NEW_REMOTE" ]; then
    CMD="git remote set-url origin $NEW_URL"
    press "About to change origin url ( $CMD )"
    $CMD
else
    CMD="git remote add $NEW_REMOTE $NEW_URL"
    press "About to create new ssh url ( $CMD )"
    echo $CMD
    $CMD
fi

echo
echo "git remote entries after change:"
git remote -v

#git remote get-url [--push] [--all] <name>
#git remote set-url [--push] <name> <newurl> [<oldurl>]
#git remote set-url --add [--push] <name> <newurl>
#git remote set-url --delete [--push] <name> <url>


exit 0


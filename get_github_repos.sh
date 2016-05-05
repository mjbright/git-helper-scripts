#!/bin/bash

USERNAME=$1

USERNAME=$(echo "$USERNAME" | sed 's/^.*:\/\/github.com\///')
USERNAME=${USERNAME%/}
echo "Using username <$USERNAME>"

#USERNAME=jupyter
HTML=repos_${USERNAME}.html

GIT_SRCDIR=$HOME/src/git

# Don't change: 
GIT_USERDIR=$GIT_SRCDIR/GIT_$USERNAME

#set -x

die() {
    echo "$0: die - $*" >&2
    exit 1
}

[ -z "$1" ] && die "No user account name specified

Usage: $0 <github_user>
    Downloads all of user repos to $GIT_SRCDIR>/<user>/<repo>

"


press() {
    echo $*
    echo "Press <return> to continue"
    read _DUMMY
    [ "$_DUMMY" == "q" ] && exit 0
    [ "$_DUMMY" == "Q" ] && exit 0
}

echo
echo "Downloading list of repos for user <$USERNAME> ..."
curl -s https://github.com/$USERNAME/ > $HTML
echo "... Done"
ls -altr $HTML

#<a href="/jupyter/docker-demo-images" itemprop="name codeRepository">

REPOS=$(USERNAME=$USERNAME perl -ne '
    my $USERNAME=$ENV{USERNAME};
    #print $USERNAME;
    if (/<a href="\/$USERNAME\/([^"]+)"/) { print $1,"\n"; }
    #if (/<a href=\"\/$USERNAME\/([^\"]+)\"/) { print $1,"\n"; }
    #if (/<a href=./$USERNAME/([^\"]+)\"/) { print $1,"\n"; }
' $HTML)

echo
echo "Repos to download: <$REPOS>"
echo
press "About to download to $GIT_USERDIR"


[ ! -d $GIT_USERDIR ] && {
    echo "mkdir -p $GIT_USERDIR";
    mkdir -p $GIT_USERDIR;
}

echo "cd $GIT_USERDIR"
cd $GIT_USERDIR

for REPO in $REPOS;do
    if [ -d $REPO ];then
        #press "OK $REPO"
        echo
        echo "Repo $USERNAME/$REPO exists ... pulling ..."
        cd $REPO
            git pull
        cd $GIT_USERDIR
    else
        #die "NOT EXPECTED"
        echo
        echo "git clone https://github.com/$USERNAME/$REPO"
        git clone https://github.com/$USERNAME/$REPO
    fi
done


exit 0


# USERNAME=mjbright
# curl -u $USERNAME -s https://api.github.com/users/$USERNAME/repos?per_page=200 > repos_${USERNAME}.txt
# ls -al repos_${USERNAME}.txt
# 
# USERNAME=ipython
# curl -u $USERNAME -s https://api.github.com/users/$USERNAME/repos?per_page=200 > repos_${USERNAME}.txt
# ls -al repos_${USERNAME}.txt
# 
# USERNAME=jupyter
# curl -u $USERNAME -s https://api.github.com/users/$USERNAME/repos?per_page=200 > repos_${USERNAME}.txt
# ls -al repos_${USERNAME}.txt
# 
# USERNAME=docker
# curl -u $USERNAME -s https://api.github.com/users/$USERNAME/repos?per_page=200 > repos_${USERNAME}.txt
# ls -al repos_${USERNAME}.txt

#grep <a href="$USERNAME/ $HTML
#echo "REPOS=$REPOS"



#!/bin/sh


OLD_USER_EMAIL_ID=$1
USERNAME=$2
NEW_USER_EMAIL=$3

[[ -z "${OLD_USER_EMAIL_ID}" ]] || [[ -z "${USERNAME}" ]] || [[ -z "${NEW_USER_EMAIL}" ]] &&
echo "[error] parameters are missing
Eg: ./change_git_commits_user_details.sh <OLD_USER_EMAIL_ID> <USERNAME> <NEW_USER_EMAIL>" && exit 123

git filter-branch --env-filter '
OLD_EMAIL="${OLD_USER_EMAIL_ID}"
CORRECT_NAME="${USERNAME}"
CORRECT_EMAIL="${NEW_USER_EMAIL}"
if [ "$GIT_COMMITTER_EMAIL" = "$OLD_EMAIL" ]
then
    export GIT_COMMITTER_NAME="$CORRECT_NAME"
    export GIT_COMMITTER_EMAIL="$CORRECT_EMAIL"
fi
if [ "$GIT_AUTHOR_EMAIL" = "$OLD_EMAIL" ]
then
    export GIT_AUTHOR_NAME="$CORRECT_NAME"
    export GIT_AUTHOR_EMAIL="$CORRECT_EMAIL"
fi
' --tag-name-filter cat -- --branches --tags

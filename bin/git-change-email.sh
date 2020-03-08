#!/bin/zsh

git filter-branch --commit-filter '
  if [ "$GIT_AUTHOR_NAME" = "Valentin Novikov" ] ;
  then
    GIT_COMMITTER_NAME="Valentin Novikov";
    GIT_AUTHOR_NAME="Valentin Novikov";
    GIT_COMMITTER_EMAIL="isnotvalya@no-email.host";
    GIT_AUTHOR_EMAIL="isnotvalya@no-email.host";
    git commit-tree "$@";
  else
    git commit-tree "$@";
  fi' -f HEAD

#!/bin/bash
BASE_DIR="$(dirname "$0")"
EXCLUDE=$BASE_DIR/exclude_pattern.txt
DEST_DIR=var/www/app/repository
DEST_HOST=$1
rsync -avz --delete --chmod=Da+xr,Du+w,Fa+r,Fu+w --exclude-from="$EXCLUDE" "$BASE_DIR" "$DEST_HOST":"$DEST_DIR"
ssh "$DST_HOST" bash -ls <<EOT
[ -f ~/.bash_profile ] && . ~/.bash_profile || . ~/.profile
cd "$DEST_DIR" && \
  bundle install --path=vendor/bundler && \
  export SECRET_KEY_BASE=`bundle exec rake secret` && \
  bundle exec rake assets:precompile && \
  bundle exec thin restart -C thin.yaml
EOT

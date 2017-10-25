FROM ruby:2.3

# 非対話形式を指定することで入力待ちを阻止
ARG DEBIAN_FRONTEND=noninteractive

ENV \
  USER=aoyagi \
  GROUP=aoyagi \
  APP_ROOT_DIR=/var/www/web \
  DB_DIR=/var/www/db

RUN \
  groupadd -r $USER && \
  useradd -r -m -g $GROUP $USER && \
  apt-get update && \
  apt-get install -y --no-install-recommends curl && \
  apt-get install -y --no-install-recommends \
    build-essential \
    libreadline-dev \
    libssl-dev \
    libxml2-dev \
    libxslt-dev \
    libyaml-dev \
    nodejs \
    postfix \
    postgresql-client \
    zlib1g-dev \
    && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* && \
  mkdir -p $APP_ROOT_DIR $DB_DIR

# bundle install に必要なファイルのみ先にコピーする
COPY Gemfile $APP_ROOT_DIR/

COPY docker/.pgpass /home/$USER

# $USERに所有権付与
RUN chown -R $USER $APP_ROOT_DIR $DB_DIR /home/$USER/.pgpass && \
  chmod 600 /home/$USER/.pgpass

# ユーザ切り替え
USER $USER

# 作業ディレクトリを設定
WORKDIR $APP_ROOT_DIR

# gem をインストール
RUN \
  gem update --system && \
  gem install bundler && \
  bundle config --global jobs 2 && \
  bundle install --path=vendor/bundler

FROM ruby:2.5.7

RUN apt-get update -qq && apt-get install -y build-essential nodejs vim

RUN mkdir /chokichoki
WORKDIR /chokichoki

# ホストのGemfileとGemfile.lockをコンテナにコピー
COPY Gemfile /chokichoki/Gemfile
COPY Gemfile.lock /chokichoki/Gemfile.lock

# bundle installの実行
RUN bundle install

# ホストのアプリケーションディレクトリ内をすべてコンテナにコピー
COPY . /chokichoki

# puma.sockを配置するディレクトリを作成
RUN mkdir tmp/sockets
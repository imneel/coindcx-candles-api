# frozen_string_literal: true

source "https://rubygems.org"
git_source(:github) {|repo| "https://github.com/#{repo}.git" }

ruby "2.6.5"

gem "bootsnap", ">= 1.4.2", require: false
gem "dotenv-rails", "~> 2.7.5"
gem "foreman", "~> 0.87.0"
gem "pg", ">= 0.18", "< 2.0"
gem "puma", "~> 4.1"
gem "rails", "~> 6.0.2", ">= 6.0.2.2"
gem "redis", "~> 4.1.3"
gem "rubocop", "~> 0.82.0"
gem "sidekiq", "~> 6.0.6"

group :development, :test do
  gem "byebug", platforms: %i[mri mingw x64_mingw]
end

group :development do
  gem "listen", ">= 3.0.5", "< 3.2"
  gem "spring"
  gem "spring-watcher-listen", "~> 2.0.0"
end

gem "awesome_print", "~> 1.8.0"
gem "faye-websocket", "~> 0.10.9"

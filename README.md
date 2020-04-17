# CoinDCX candles API

## Setup

If you are linux replace brew with your package manager.

1. Install `postgresql` -> `brew install postgresql`
2. Install the ruby mentioned in `.ruby-version` along with `bundler` (We prefer `rbenv`)
3. Run `bundle install`
4. Make sure services are running -> `brew services start postgresql`
5. Run `bundle exec foreman run rails db:create db:migrate db:seed`
6. Run `bundle exec foreman start`

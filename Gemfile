source "https://rubygems.org"

ruby "3.2.6"

gem "rails", "~> 7.2.3", ">= 7.2.3.2"
gem "pg"
gem "puma"
gem "bootsnap", require: false

gem "propshaft"
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "dartsass-rails"

gem "jbuilder"
gem "bcrypt", "~> 3.1.12"
gem "solid_queue"

group :development, :test do
  gem "debug", platforms: %i[mri]
  gem "brakeman", require: false
  gem "bundler-audit", require: false
end

group :development do
  gem "web-console"
end

group :test do
  gem "rails-controller-testing"
  gem "minitest", "~> 5.25"
end

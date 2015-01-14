source "http://rubygems.org"

# Specify your gem's dependencies in guard-process.gemspec
gemspec development_group: :gem_build_tools

group :gem_build_tools do
  gem 'rake' # for creating releases
end

# Note: this is the only group ignored on Travis
group :development do
  gem 'guard-minitest'
  gem 'guard-bundler'
  gem 'pry'
end

group :test do
  gem 'minitest'
  gem 'mocha'
end

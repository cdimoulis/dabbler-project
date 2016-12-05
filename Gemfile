source 'https://rubygems.org'
ruby '2.3.1'

# Standard gems
gem 'rails', '4.2.6'
gem 'responders', '~>2.3.0'
gem 'pg', '~> 0.18.3'
gem 'passenger', '~> 5.0.30'
gem 'sidekiq',  '~> 4.2.3'
gem 'redis-rails', '~> 4.0.0'

# Authentication
# gem 'devise', '~> 4.2.0'
gem 'clearance', '~> 1.15.1'

# Page markup and style gems
gem 'sass-rails', '~> 5.0.6'
gem 'uglifier', '>= 3.0.3'
gem 'coffee-rails', '~> 4.2.1'
gem 'haml',   '~> 4.0.7'
gem 'haml-rails', '~> 0.9'
gem 'handlebars_assets', '~> 0.21'

# Client side gems, libraries, etc.
gem 'jquery-rails', '~> 4.2.1'
gem 'jquery-ui-rails', '~> 5.0.5'

# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

gem 'sprockets-rails', '~> 3.2.0'

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'

  gem 'rspec-rails', '~> 3.5.2'
  gem 'factory_girl_rails', '~> 4.7.0'
  gem 'database_cleaner', '~> 1.5.3'
  gem 'capybara', '~> 2.10.1'
  gem 'shoulda-matchers', '~> 3.1.1', require: false
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-commands-rspec'

  gem 'foreman', '~> 0.78'
  gem 'annotate'
  gem 'better_errors'
  gem 'minitest', '~> 5.8.4'
end

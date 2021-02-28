source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.0.0'

# -------- rails included --------
gem 'rails', '~> 6.1.3'

gem 'bcrypt', '~> 3.1.7'
gem 'bootsnap', '>= 1.4.4', require: false
gem 'jbuilder', '~> 2.7'
gem 'pg', '~> 1.1'
gem 'puma', '~> 5.0'
gem 'sass-rails', '>= 6'
gem 'turbolinks', '~> 5'
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
gem 'webpacker', '~> 5.0'
# gem 'image_processing', '~> 1.2' # optional rails include
# gem 'redis', '~> 4.0'            # optional rails include

# -------- included by us --------

group :development, :test do
  # -------- rails included --------
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]

  # -------- included by us --------
end

group :development do
  # -------- rails included --------
  gem 'listen', '~> 3.3'
  gem 'rack-mini-profiler', '~> 2.0'
  gem 'web-console', '>= 4.1.0'

  # -------- included by us --------
end

group :test do
  # -------- rails included --------
  gem 'capybara', '>= 3.26'
  gem 'selenium-webdriver'
  gem 'webdrivers'

  # -------- included by us --------
  # separate gem on ruby, 3.0. selenium-webdriver isn't properly listing it as a dependency causing
  # errors in tests. they've fixed this on 4.0.0, but it's in beta, atm.
  #
  # ref: https://github.com/rails/rails/issues/41502
  # ref: https://github.com/SeleniumHQ/selenium/commit/526fd9d0de60a53746ffa982feab985fed09a278
  gem 'rexml'
end

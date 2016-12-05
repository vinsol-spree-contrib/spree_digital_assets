# encoding: UTF-8
Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'spree_digital_assets'
  s.version     = '3.2.0'
  s.summary     = 'Add gem summary here'
  s.description = 'Add (optional) gem description here'
  s.required_ruby_version = '>= 2.0.0'

  s.authors    = ['Ankit Kalia', 'Siddharth Sharma']
  s.email     = 'info@vinsol.com'
  s.homepage  = 'http://vinsol.com'

  s.files       = `git ls-files`.split("\n")
  #s.test_files  = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_path = 'lib'
  s.requirements << 'none'

  s.add_dependency 'spree_core', '~> 3.2.alpha'
  s.add_dependency 'remotipart', '~> 1.2'
  s.add_dependency 'jquery-fileupload-rails', '~> 0.4.6'

  s.add_development_dependency 'shoulda-matchers', '~> 2.6.2'
  s.add_development_dependency 'rspec-activemodel-mocks'

  s.add_development_dependency 'capybara', '~> 2.5'
  s.add_development_dependency 'coffee-rails'
  s.add_development_dependency 'database_cleaner'
  s.add_development_dependency 'factory_girl', '~> 4.5'
  s.add_development_dependency 'ffaker',  '~> 2.2.0'
  s.add_development_dependency 'rspec-rails',  '~> 3.4'
  s.add_development_dependency 'sass-rails', '~> 5.0.0'
  s.add_development_dependency 'selenium-webdriver'
  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'sqlite3'
end

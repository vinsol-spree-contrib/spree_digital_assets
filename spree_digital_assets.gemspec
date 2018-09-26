# encoding: UTF-8
Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'spree_digital_assets'
  s.version     = '3.3.0'
  s.summary     = 'This extension allows you to have a central repository of the assets.'
  s.description = 'This extension allows you to have a central repository of the assets. The assets can be uploaded well
    in advance and can be associated with the products/variants at the time of product/variant creation.
    This will also act as a central repository that can be used to access all the assets of the system
    and can then be used in different products.
  '
  s.required_ruby_version = '>= 2.2.7'

  s.authors    = ['Ankit Kalia', 'Siddharth Sharma']
  s.email     = 'info@vinsol.com'
  s.homepage  = 'http://vinsol.com'

  s.files       = `git ls-files`.split("\n")
  s.test_files  = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_path = 'lib'
  s.requirements << 'none'

  s.add_dependency 'spree_core', '>= 3.2.0', '< 4.0'
  s.add_dependency 'spree_extension'
  s.add_dependency 'remotipart'
  s.add_dependency 'jquery-fileupload-rails', '~> 0.4.6'

  s.add_development_dependency 'appraisal'
  s.add_development_dependency 'bootstrap-toggle-rails'
  s.add_development_dependency 'capybara', '~> 2.5'
  s.add_development_dependency 'coffee-rails'
  s.add_development_dependency 'database_cleaner'
  s.add_development_dependency 'factory_girl', '~> 4.5'
  s.add_development_dependency 'ffaker',  '~> 2.2.0'
  s.add_development_dependency 'rails-controller-testing'
  s.add_development_dependency 'rspec-activemodel-mocks'
  s.add_development_dependency 'rspec-rails',  '~> 3.4'
  s.add_development_dependency 'sass-rails', '~> 5.0.0'
  s.add_development_dependency 'shoulda-matchers', '~> 2.6.2'
  s.add_development_dependency 'selenium-webdriver'
  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'sqlite3'
end

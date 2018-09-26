module SpreeDigitalAssets
  class Engine < Rails::Engine
    require 'spree/core'
    isolate_namespace Spree
    engine_name 'spree_digital_assets'

    # use rspec for tests
    config.generators do |g|
      g.test_framework :rspec
    end

    initializer 'spree_digital_assets.assets.precompile' do |app|
      app.config.assets.precompile += %w[
        spree/backend/bootstrap_toggle.css
        spree/backend/bootstrap_toggle.js
        spree/backend/spree_digital_assets/banner_toggler.js
      ]
    end

    def self.activate
      Dir.glob(File.join(File.dirname(__FILE__), '../../app/**/*_decorator*.rb')) do |c|
        Rails.configuration.cache_classes ? require(c) : load(c)
      end
    end

    config.to_prepare &method(:activate).to_proc
  end
end

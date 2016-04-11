module SpreeDigitalAssets
  class Engine < Rails::Engine
    require 'spree/core'
    isolate_namespace Spree
    engine_name 'spree_digital_assets'

    # use rspec for tests
    config.generators do |g|
      g.test_framework :rspec
    end

    def self.activate
      Dir.glob(File.join(File.dirname(__FILE__), '../../app/**/*_decorator*.rb')) do |c|
        Rails.configuration.cache_classes ? require(c) : load(c)
      end
    end

    initializer 'spree.assets.precompile', group: :all do |app|
      app.config.assets.precompile += %w( default_file_icon.png folder_icon.png )
    end

    config.to_prepare &method(:activate).to_proc
  end
end

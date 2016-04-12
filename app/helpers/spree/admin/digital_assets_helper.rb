module Spree
  module Admin
    module DigitalAssetsHelper
      def related_products(digital_asset)
        digital_asset.assets.map do |asset|
          { parameterize_name: asset.viewable.product.name.parameterize, human_readable_name: asset.viewable.product.name }
        end
      end
    end
  end
end

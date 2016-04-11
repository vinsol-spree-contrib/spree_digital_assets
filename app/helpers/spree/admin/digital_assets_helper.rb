module Spree
  module Admin
    module DigitalAssetsHelper
      def related_products(digital_asset)
        digital_asset.assets.map do |asset|
          [asset.viewable.product.name.parameterize, asset.viewable.product.name]
        end.to_h
      end
    end
  end
end

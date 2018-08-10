class AddMobileBannerToSpreeBanners < ActiveRecord::Migration[5.1]
  def change
    add_column :spree_banners, :mobile_banner, :boolean, default: false, null: false
  end
end

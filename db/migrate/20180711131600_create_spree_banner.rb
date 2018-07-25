class CreateSpreeBanner < ActiveRecord::Migration[5.1]
  def change
    create_table :spree_banners do |t|
      t.string :title
      t.boolean :active, default: false
      t.string :link
      t.attachment :attachment
      t.timestamps
    end
  end
end

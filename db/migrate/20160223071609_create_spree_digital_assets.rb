class CreateSpreeDigitalAssets < ActiveRecord::Migration
  def change
    create_table :spree_digital_assets do |t|
      t.string :name
      t.attachment :attachment
      t.timestamps null: false
      t.references :folder
    end
  end
end

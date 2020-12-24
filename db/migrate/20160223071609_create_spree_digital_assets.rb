class CreateSpreeDigitalAssets < SpreeExtension::Migration[4.2]
  def change
    create_table :spree_digital_assets do |t|
      t.string :name
      t.references :folder

      t.timestamps null: false
    end
  end
end

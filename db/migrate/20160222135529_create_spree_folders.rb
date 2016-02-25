class CreateSpreeFolders < ActiveRecord::Migration
  def change
    create_table :spree_folders do |t|
      t.references :parent
      t.string     :name
      t.integer    :lft
      t.integer    :rgt
      t.timestamps null: false
    end
  end
end

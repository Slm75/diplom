class CreatePermissions < ActiveRecord::Migration
  def change
    create_table :permissions do |t|
      t.string :name
      t.integer :description

      t.timestamps null: false
    end
  end
end

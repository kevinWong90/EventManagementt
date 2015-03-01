class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :name
      t.string :type
      t.string :belongsTo
      t.integer :owner_id

      t.timestamps
    end
  end
end

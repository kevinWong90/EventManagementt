class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :name
      t.string :description
      t.string :visibility
      t.string :type
      t.string :location
      t.string :postalCode
      t.string :country
      t.datetime :startDate
      t.datetime :endDate
      t.integer :maxCapacity

      t.timestamps
    end
  end
end

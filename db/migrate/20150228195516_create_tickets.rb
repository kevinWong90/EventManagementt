class CreateTickets < ActiveRecord::Migration
  def change
    create_table :tickets do |t|
      t.string :type
      t.string :price
      t.string :barcode
      t.boolean :isClaimed, :default => false
      t.integer :user_id
      t.integer :event_id

      t.timestamps
    end
  end
end

class AddQuantityToTickets < ActiveRecord::Migration
  def change
    add_column :tickets, :quantity, :string
  end
end

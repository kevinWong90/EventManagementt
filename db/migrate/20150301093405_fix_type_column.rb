class FixTypeColumn < ActiveRecord::Migration
  def change
  	rename_column :categories, :type, :categoryType
  	rename_column :tickets, :type, :ticketType
  	rename_column :events, :type, :eventType
  end
end

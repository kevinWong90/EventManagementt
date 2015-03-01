class CreateEventUserRelations < ActiveRecord::Migration
  def change
    create_table :event_user_relations do |t|
      t.integer :event_id
      t.integer :user_id
      t.integer :organization_id
      t.string :userRole

      t.timestamps
    end
  end
end

class CreateOrganizationUserRelations < ActiveRecord::Migration
  def change
    create_table :organization_user_relations do |t|
      t.integer :organization_id
      t.integer :user_id
      t.string :userRole
      t.string :userOccupationTitle

      t.timestamps
    end
  end
end

class CreateMembers < ActiveRecord::Migration[5.2]
  def change
    create_table :members do |t|
      t.integer :userId
      t.integer :projectId
      t.boolean :isAdmin

      t.timestamps
    end
  end
end

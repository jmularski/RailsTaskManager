class RenameLeader < ActiveRecord::Migration[5.2]
  def change
    rename_table :users, :leaders
  end
end

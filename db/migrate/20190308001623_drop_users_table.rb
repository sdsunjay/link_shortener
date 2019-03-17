class DropUsersTable < ActiveRecord::Migration[5.2]
  def up
    drop_table :users, force: :cascade
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end

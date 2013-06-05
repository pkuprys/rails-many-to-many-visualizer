class AddIndexToHosts < ActiveRecord::Migration
  def change
    add_index :hosts, [:name, :user_id]
  end
end

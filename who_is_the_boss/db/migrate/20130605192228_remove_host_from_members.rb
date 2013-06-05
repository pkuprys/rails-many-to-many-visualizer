class RemoveHostFromMembers < ActiveRecord::Migration
  def up
    remove_column :members, :host
  end

  def down
    add_column :members, :host, :string
  end
end

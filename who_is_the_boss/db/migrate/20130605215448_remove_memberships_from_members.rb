class RemoveMembershipsFromMembers < ActiveRecord::Migration
  def up
    remove_column :members, :membership_id
  end

  def down
    add_column :members, :membership_id, :integer
  end
end

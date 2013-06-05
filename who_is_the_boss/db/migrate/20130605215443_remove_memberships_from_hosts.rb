class RemoveMembershipsFromHosts < ActiveRecord::Migration
  def up
    remove_column :hosts, :membership_id
  end

  def down
    add_column :hosts, :membership_id, :integer
  end
end

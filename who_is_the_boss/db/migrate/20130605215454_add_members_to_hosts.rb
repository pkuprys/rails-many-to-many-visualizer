class AddMembersToHosts < ActiveRecord::Migration
  def change
    add_column :hosts, :member_id, :integer
  end
end

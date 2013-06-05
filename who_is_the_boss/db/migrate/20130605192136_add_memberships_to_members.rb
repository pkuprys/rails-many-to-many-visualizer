class AddMembershipsToMembers < ActiveRecord::Migration
  def change
    add_column :members, :membership_id, :integer
  end
end

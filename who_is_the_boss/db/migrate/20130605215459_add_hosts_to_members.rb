class AddHostsToMembers < ActiveRecord::Migration
  def change
    add_column :members, :host_id, :integer
  end
end

class CreateHostsMembersTable < ActiveRecord::Migration
  def up
    create_table :hosts_members, :id => false do |t|
        t.references :host
        t.references :member
    end
    add_index :hosts_members, [:host_id, :member_id]
  end

  def down
    drop_table :hosts_members
  end
end

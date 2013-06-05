class RemoveCategoryAndMemberFromHosts < ActiveRecord::Migration
  def up
    remove_column :hosts, :category
    remove_column :hosts, :member
  end

  def down
    add_column :hosts, :member, :string
    add_column :hosts, :category, :string
  end
end

class AddMembershipsAndCategoryIdsToHosts < ActiveRecord::Migration
  def change
    add_column :hosts, :category_id, :integer
    add_column :hosts, :membership_id, :integer
  end
end

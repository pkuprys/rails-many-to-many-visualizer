class UpdateHosts < ActiveRecord::Migration
  def change
      remove_column :member
      remove_column :category
      add_column :membership_id
      add_column :category_id
    end
end
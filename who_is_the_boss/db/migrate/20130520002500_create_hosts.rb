class CreateHosts < ActiveRecord::Migration
  def change
    create_table :hosts do |t|
      t.string :name
      t.string :member
      t.string :category

      t.timestamps
    end
  end
end

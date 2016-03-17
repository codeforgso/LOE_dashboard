class AddColumnsToTable < ActiveRecord::Migration
  def change
    change_table :inspections do |t|
      t.string :city
      t.string :state
      t.text :full_address
      t.string :inspection_id
      t.float :x_coord
      t.float :y_coord
      t.integer :ad_sakey
    end
    change_table :violations do |t|
      t.string :city
      t.string :state
      t.text :full_address
      t.string :violation_id
      t.float :x_coord
      t.float :y_coord
      t.integer :ad_sakey
    end
  end
end

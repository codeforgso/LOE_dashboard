class AddNewColumnsToLoeCases < ActiveRecord::Migration
  def change
    change_table :loe_cases do |t|
      t.string :city
      t.text :full_address
      t.string :state
      t.string :stpfxdir
      t.string :stsfxdir
      t.string :st_apt
      t.string :st_name
      t.string :st_number
      t.string :st_type
      t.float :x_coord
      t.float :y_coord
    end
  end
end

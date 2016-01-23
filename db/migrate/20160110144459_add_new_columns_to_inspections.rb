class AddNewColumnsToInspections < ActiveRecord::Migration
  def change
    change_table :inspections do |t|
      t.string :stpfxdir
      t.string :stsfxdir
      t.string :st_apt
      t.string :st_name
      t.string :st_number
      t.string :st_type
    end
  end
end

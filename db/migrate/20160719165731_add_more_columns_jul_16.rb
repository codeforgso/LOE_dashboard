class AddMoreColumnsJul16 < ActiveRecord::Migration
  def change
    change_table :inspections do |t|
      t.string :case_type
      t.string :case_status
    end
  end
end

class AddColumnsToViolations < ActiveRecord::Migration
  def change
    change_table :violations do |t|
      t.string :owner_mailzip
      t.string :ad_lot
      t.string :close_reason
      t.string :owner_name
      t.string :owner_mailstate
      t.string :case_notes
      t.date :due_date
      t.string :owner_mailcity
      t.string :zoning
      t.string :owner_mailaddr2
      t.string :census_tract
      t.string :rental_status
      t.string :owner_name2
      t.string :origin
      t.date :close_date
      t.string :use_code
      t.string :assigned_insp_code
      t.string :owner_mailaddr
      t.string :assignment
      t.string :case_status
      t.string :case_type
      t.date :annex_date
    end
  end
end

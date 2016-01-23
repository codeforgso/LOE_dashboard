class CreateLoeCases < ActiveRecord::Migration
  def change
    create_table :loe_cases do |t|
      t.string :ad_lot
      t.integer :ad_sakey
      t.string :ad_st_apt
      t.string :ad_st_name
      t.string :ad_st_num
      t.string :ad_st_type
      t.date :annex_date
      t.string :assigned_inspector_code
      t.string :assignment
      t.text :case_notes
      t.integer :case_number
      t.string :case_status
      t.string :case_type
      t.string :census_tract
      t.datetime :close_date
      t.string :close_reason
      t.datetime :due_date
      t.datetime :entry_date
      t.datetime :last_update
      t.string :origin
      t.string :owner_mailaddr
      t.string :owner_mailaddr2
      t.string :owner_mailcity
      t.string :owner_mailstate
      t.string :owner_mailzip
      t.string :owner_name
      t.string :owner_name2
      t.string :rental_status
      t.string :use_code
      t.string :zoning

      t.timestamps null: false
    end
  end
end

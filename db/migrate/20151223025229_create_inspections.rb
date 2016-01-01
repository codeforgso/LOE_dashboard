class CreateInspections < ActiveRecord::Migration
  def change
    create_table :inspections do |t|
      t.integer :loe_case_id
      t.string :ad_st_apt
      t.string :ad_st_name
      t.string :ad_st_num
      t.string :ad_st_type
      t.integer :case_number
      t.integer :case_sakey
      t.string :compliant
      t.datetime :entry_date
      t.datetime :inspection_date
      t.text :inspection_notes
      t.integer :inspection_sakey
      t.string :inspection_type
      t.string :inspection_type_desc
      t.string :inspector
      t.datetime :last_update
      t.string :open_and_vacant
      t.string :unfounded

      t.timestamps null: false
    end
  end
end

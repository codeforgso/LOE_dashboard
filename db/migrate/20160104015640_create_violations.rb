class CreateViolations < ActiveRecord::Migration
  def change
    create_table :violations do |t|
      t.integer :loe_case_id
      t.string :ad_st_name
      t.string :ad_st_num
      t.string :ad_st_type
      t.integer :case_number
      t.integer :case_sakey
      t.datetime :clear_date
      t.string :cleared_by
      t.datetime :entry_date
      t.string :issued_by
      t.datetime :issued_date
      t.datetime :last_update
      t.integer :number_of_items
      t.datetime :reissue_date
      t.string :reissued_by
      t.string :violation_cleared
      t.string :violation_code
      t.string :violation_description
      t.string :violation_issued
      t.string :violation_reissued
      t.integer :violation_sakey
      t.string :major_violation
      t.string :responsible_party
      t.text :comments
      t.string :ad_st_apt

      t.timestamps null: false
    end
  end
end

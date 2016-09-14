class AddIndexToLoeCases < ActiveRecord::Migration
  def change
    add_index :loe_cases, :case_number, unique: true
  end
end

class CreateCaseTypes < ActiveRecord::Migration
  def change
    create_table :case_types do |t|
      t.string :name

      t.timestamps null: false
    end
    add_index :case_types, :name, unique: true
  end
end

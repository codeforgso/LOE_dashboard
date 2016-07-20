class CreateCaseStatuses < ActiveRecord::Migration
  def change
    create_table :case_statuses do |t|
      t.string :name, null: false

      t.timestamps null: false
    end
    add_index :case_statuses, :name, unique: true
  end
end

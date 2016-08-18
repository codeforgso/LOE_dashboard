class CreateUseCodes < ActiveRecord::Migration
  def change
    create_table :use_codes do |t|
      t.string :name, null: false

      t.timestamps null: false
    end
    add_index :use_codes, :name, unique: true
  end
end

class CreateRentalStatuses < ActiveRecord::Migration
  def change
    create_table :rental_statuses do |t|
      t.string :name, null: false

      t.timestamps null: false
    end
    add_index :rental_statuses, :name, unique: true
  end
end

class SetupRentalStatusToLoeCaseRelationship < ActiveRecord::Migration
  def up
    add_column :loe_cases, :rental_status_id, :integer
    add_index :loe_cases, :rental_status_id
    rental_statuses = {}
    LoeCase.select('distinct(rental_status)').map(&:rental_status).compact.each do |rental_status|
      rental_statuses[rental_status] ||= RentalStatus.create(name: rental_status)
      LoeCase.connection.execute "UPDATE loe_cases SET rental_status_id = #{rental_statuses[rental_status].id} WHERE rental_status = '#{rental_status}'"
    end
    remove_column :loe_cases, :rental_status
  end

  def down
    add_column :loe_cases, :rental_status, :string
    RentalStatus.all.each do |rental_status|
      LoeCase.connection.execute "UPDATE loe_cases SET rental_status = '#{rental_status.name}' WHERE rental_status_id = #{rental_status.id}"
    end
    remove_index :loe_cases, :rental_status_id
    remove_column :loe_cases, :rental_status_id
  end
end

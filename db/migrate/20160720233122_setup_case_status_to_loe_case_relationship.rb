class SetupCaseStatusToLoeCaseRelationship < ActiveRecord::Migration
  def up
    add_column :loe_cases, :case_status_id, :integer
    add_index :loe_cases, :case_status_id
    open_status = CaseStatus.where(name: 'Open').first || CaseStatus.create(name: 'Open')
    closed_status = CaseStatus.where(name: 'Closed').first || CaseStatus.create(name: 'Closed')
    LoeCase.connection.execute "UPDATE loe_cases SET case_status_id = #{open_status.id} WHERE case_status = 'Open'"
    LoeCase.connection.execute "UPDATE loe_cases SET case_status_id = #{closed_status.id} WHERE case_status = 'Closed'"
    remove_column :loe_cases, :case_status
  end
  def down
    add_column :loe_cases, :case_status, :string
    open_status = CaseStatus.where(name: 'Open').first
    closed_status = CaseStatus.where(name: 'Closed').first
    LoeCase.connection.execute "UPDATE loe_cases SET case_status = 'Open' WHERE case_status_id = #{open_status.id}"
    LoeCase.connection.execute "UPDATE loe_cases SET case_status = 'Closed' WHERE case_status = #{closed_status.id}"
    remove_index :loe_cases, :case_status_id
    remove_column :loe_cases, :case_status_id
  end
end

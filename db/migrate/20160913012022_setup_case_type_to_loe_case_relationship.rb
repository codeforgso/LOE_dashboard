class SetupCaseTypeToLoeCaseRelationship < ActiveRecord::Migration
  def up
    add_column :loe_cases, :case_type_id, :integer
    add_index :loe_cases, :case_type_id
    LoeCase.select('distinct(case_type)').map(&:case_type).compact.each do |name|
      case_type = CaseType.create! name: name
      LoeCase.connection.execute "UPDATE loe_cases SET case_status_id = #{case_type.id} WHERE case_status = '#{name}'"
    end
    remove_column :loe_cases, :case_type
  end

  def down
    add_column :loe_cases, :case_type, :string
    CaseType.all.each do |case_type|
      LoeCase.connection.execute "UPDATE loe_cases SET case_type = '#{case_type.name}' WHERE case_type_id = #{case_type.id}"
    end
    remove_index :loe_cases, :case_type_id
    remove_column :loe_cases, :case_type_id
  end
end

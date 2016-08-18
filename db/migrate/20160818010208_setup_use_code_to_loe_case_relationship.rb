class SetupUseCodeToLoeCaseRelationship < ActiveRecord::Migration
  def up
    add_column :loe_cases, :use_code_id, :integer
    add_index :loe_cases, :use_code_id
    use_codes = {}
    LoeCase.select('distinct(use_code)').map(&:use_code).compact.each do |use_code|
      name = UseCode.remap_name(use_code)
      use_codes[name] ||= UseCode.create(name: name)
      LoeCase.connection.execute "UPDATE loe_cases SET use_code_id = #{use_codes[name].id} WHERE use_code = '#{use_code}'"
    end
    puts [
      'TODO: Finish this migration manually!!!!',
      'Make sure we have good looking values in :use_code_id field.',
      'Then delete the old column with this command:',
      "\tActiveRecord::Migration.remove_column(:loe_cases, :use_code)"
    ].join("\n")
    # remove_column :loe_cases, :use_code
  end
  def down
    add_column :loe_cases, :use_code, :string
    UseCode.all.each do |use_code|
      LoeCase.connection.execute "UPDATE loe_cases SET use_code = '#{use_code.name}' WHERE use_code_id = #{use_code.id}"
    end
    remove_index :loe_cases, :use_code_id
    remove_column :loe_cases, :use_code_id
  end
end

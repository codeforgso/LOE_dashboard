class RemoveUnusedColumns < ActiveRecord::Migration

  def change
    settings.each do |table_hash|
      table_hash[:fields].each do |field|
        unless field.kind_of?(Hash)
          field = {name: field}
        end
        field[:type] ||= :string
        field[:opts] ||= {}
        remove_column table_hash[:table], field[:name], field[:type], field[:opts]
      end
    end
  end

  private

  def settings
    [
      {
        table: :loe_cases,
        fields: [:ad_st_apt, :ad_st_name, :ad_st_num, :ad_st_type]
      }, {
        table: :inspections,
        fields: [:ad_st_apt, :ad_st_name, :ad_st_num, :ad_st_type, :open_and_vacant]
      }, {
        table: :violations,
        fields: [
          :ad_st_apt, :ad_st_name, :ad_st_num, :ad_st_type
        ]
      }
    ]
  end
end

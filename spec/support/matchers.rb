RSpec::Matchers.define :have_socrata_attribute_remapping do
  match do |actual|
    expect(actual.constants).to include(:SOCRATA_ATTRIBUTE_REMAPPING)
    expect(actual.const_get('SOCRATA_ATTRIBUTE_REMAPPING')).to be_a(Hash)
    actual.const_get('SOCRATA_ATTRIBUTE_REMAPPING').each do |key,value|
      expect(actual.column_names).not_to include(key)
      expect(actual.column_names).to include(value)
    end
  end
end
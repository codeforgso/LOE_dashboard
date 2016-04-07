def assert_socrata_attribute_remapping(klass)
  assert klass.constants.include? :SOCRATA_ATTRIBUTE_REMAPPING
  assert klass.const_get("SOCRATA_ATTRIBUTE_REMAPPING").kind_of? Hash
  dbg = {column_names: klass.column_names.sort}
  klass.const_get("SOCRATA_ATTRIBUTE_REMAPPING").each do |key,value|
    dbg[:key] = key
    dbg[:value] = value
    assert !klass.column_names.include?(key), dbg.to_json
    assert klass.column_names.include?(value), dbg.to_json
  end
end
module CasesHelper

  def options_for_use_code(selected=nil)
    options_from_collection_for_select UseCode.all.order(:name), :id, :name, selected
  end

  def sort_dir(attribute)
    if attribute.to_s == params[:sort].to_s
      params[:sort_dir] == 'DESC' ? 'ASC' : 'DESC'
    else
      'DESC'
    end
  end

  def case_items(loe_case)
    [:case_number, :case_type, :origin, :entry_date].map do |attribute|
      {
        label: attribute.to_s.titleize,
        value: loe_case.send(attribute)
      }
    end
  end

  def case_address_items(loe_case, opts = {})
    if opts[:owner]
      items = [:owner_name2, :owner_mailaddr, :owner_mailaddr2]
      address_city = loe_case.owner_mailcity
      address_state = loe_case.owner_mailstate
      address_zip = loe_case.owner_mailzip
    else
      items = [:full_address]
      address_city = loe_case.city
      address_state = loe_case.state
      address_zip = '' #loe_case.zip
    end
    items.map do |item|
      loe_case[item] unless loe_case[item].blank?
    end.compact + [
      "#{address_city}, #{address_state} #{address_zip}"
    ]
  end

end

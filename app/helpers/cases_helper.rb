module CasesHelper

  def options_for_use_code(selected=nil)
    options_for_relation UseCode, selected
  end

  def options_for_rental_status(selected=nil)
    options_for_relation RentalStatus, selected
  end

  def options_for_case_type(selected=nil)
    options_for_relation CaseType, selected
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

  private

  def options_for_relation(klass, selected=nil)
    Rails.cache.fetch("options_for_relation-#{klass}-#{selected}") do
      options_from_collection_for_select klass.all.order(:name), :id, :name, selected
    end
  end

end

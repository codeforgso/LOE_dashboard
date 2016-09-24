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

  def search_fields
    ([ { attr: :case_number } ] + search_date_fields + [
      {
        attr: :owner_name,
        html_opts: autocomplete_field_opts(:owner_name)
      }, {
        attr: :st_name,
        title: 'Street Name',
        html_opts: autocomplete_field_opts(:st_name)
      }, {
        attr: :full_address,
        title: 'Address',
        html_opts: autocomplete_field_opts(:full_address)
      }, {
        attr: :use_code,
        html: select_tag('filters[use_code]', options_for_use_code(params[:filters][:use_code]), include_blank: true, class: 'form-control')
      }, {
        attr: :rental_status,
        html: select_tag('filters[rental_status]', options_for_rental_status(params[:filters][:rental_status]), include_blank: true, class: 'form-control')
      }, {
        attr: :case_type,
        html: select_tag('filters[case_type]', options_for_case_type(params[:filters][:case_type]), include_blank: true, class: 'form-control')
      }
    ]).map do |field|
      field[:title] ||= field[:attr].to_s.titleize
      field[:html_opts] ||= {}
      field[:value] ||= params[:filters][field[:attr]]
      field[:param_name] ||= "filters[#{field[:attr]}]"
      field[:html] ||= text_field_tag(field[:param_name], field[:value], field[:html_opts])
      field
    end
  end

  def case_items(loe_case)
    [:case_number, :case_type, :origin, :entry_date].map do |attribute|
      value = case attribute
      when :case_type
        loe_case.send(attribute).try(:name)
      else
        loe_case.send(attribute)
      end
      {
        label: attribute.to_s.titleize,
        value: value
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

  def date_field_opts
    {
      data: {
        provide: :datepicker,
        'date-autoclose': true,
        'date-today-highlight': true,
        'date-days-of-week-highlighted': '1,2,3,4,5',
        'date-format': 'yyyy-mm-dd',
        'date-orientation': 'bottom'
      }
    }
  end

  def autocomplete_field_opts(item)
    {
      data: {
        autocomplete: true,
        autocomplete_param: item
      },
      autocomplete: :off
    }
  end

  def search_date_fields
    params[:filters][:entry_date_range] ||= {}
    [
      {
        attr: :start_date,
        title: 'Entry Date',
        sub_title: '(start)',
        param_name: 'filters[entry_date_range][start_date]',
        value: search_date_field_value(:start_date),
        html_opts: date_field_opts
      }, {
        attr: :end_date,
        title: 'Entry Date',
        sub_title: '(end)',
        param_name: 'filters[entry_date_range][end_date]',
        value: search_date_field_value(:end_date),
        html_opts: date_field_opts
      }
    ]
  end

  def search_date_field_value(key)
    if params[:filters][:entry_date_range][key].respond_to?(:strftime)
      params[:filters][:entry_date_range][key].try(:strftime, '%Y-%m-%d')
    else
      params[:filters][:entry_date_range][key]
    end
  end

end

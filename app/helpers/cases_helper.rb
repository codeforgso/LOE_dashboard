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

end

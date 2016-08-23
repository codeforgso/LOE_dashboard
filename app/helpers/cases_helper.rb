module CasesHelper

  def options_for_use_code(selected=nil)
    options_from_collection_for_select UseCode.all.order(:name), :id, :name, selected
  end

end

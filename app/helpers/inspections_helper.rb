module InspectionsHelper

  def unique_inspection_id(inspection)
    entry_date = inspection.entry_date
    inspection_date = inspection.inspection_date
    "#{inspection.case_number}*#{entry_date ? entry_date.to_i : nil}*#{inspection_date ? inspection_date.to_i : nil}"
  end
end

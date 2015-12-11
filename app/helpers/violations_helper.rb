module ViolationsHelper

  def unique_violation_id(violation)
    entry_date = Time.parse violation.entry_date
    "#{violation.case_number}*#{entry_date ? entry_date.to_i : nil}*#{violation.violation_code}"
  end

end

module CaseHistoriesHelper

  def unique_case_history_id(case_history)
    "#{case_history.case_number}*#{case_history.case_history_sakey}"
  end

end

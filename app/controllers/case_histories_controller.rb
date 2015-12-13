require File.expand_path(Rails.root)+'/lib/socrata'
class CaseHistoriesController < ApplicationController

  def index
    socrata = Socrata.new
    params[:filters] ||= {}
    opts = {'$order': 'date, case_number'}
    if params[:filters][:case]
      opts['$where'] = "case_number = '#{params[:filters][:case]}'"
    end
    @case_histories = socrata.paginate(socrata.case_history_dataset_id, params[:page], opts)
  end

  def show
    socrata = Socrata.new
    case_number = params[:id].split('*').first
    case_history_sakey = params[:id].split('*')[1]
    opts = {
      '$where': "case_number = '#{case_number}' and case_history_sakey='#{case_history_sakey}'"
    }
    @case_history = socrata.client.get(socrata.case_history_dataset_id, opts).first
  end

end

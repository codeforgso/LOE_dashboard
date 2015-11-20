require File.expand_path(Rails.root)+'/lib/socrata'
class CaseHistoriesController < ApplicationController

  def index
    socrata = Socrata.new
    @case_histories = socrata.paginate(socrata.case_history_dataset_id, params[:page], {'$order': 'date, case_number'})
  end

  def show
    socrata = Socrata.new
    @case_history = socrata.client.get(socrata.case_history_dataset_id, {'$where': "case_number = '#{params[:id]}'"}).first
  end

end

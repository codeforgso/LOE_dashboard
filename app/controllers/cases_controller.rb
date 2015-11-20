require File.expand_path(Rails.root)+'/lib/socrata'
class CasesController < ApplicationController

  def index
    socrata = Socrata.new
    @cases = socrata.paginate(socrata.case_dataset_id, params[:page], {'$order': 'entry_date, case_number'})
  end

  def show
    socrata = Socrata.new
    @case = socrata.client.get(socrata.case_dataset_id, {'$where': "case_number = '#{params[:id]}'"}).first
  end

end

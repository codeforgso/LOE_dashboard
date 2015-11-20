require File.expand_path(Rails.root)+'/lib/socrata'
class InspectionsController < ApplicationController

  def index
    socrata = Socrata.new
    @inspections = socrata.paginate(socrata.inspection_dataset_id, params[:page], {'$order': 'inspection_date, case_number'})
  end

  def show
    socrata = Socrata.new
    @inspection = socrata.client.get(socrata.inspection_dataset_id, {'$where': "case_number = '#{params[:id]}'"}).first
  end

end

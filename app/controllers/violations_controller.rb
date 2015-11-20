require File.expand_path(Rails.root)+'/lib/socrata'
class ViolationsController < ApplicationController

  def index
    socrata = Socrata.new
    @violations = socrata.paginate(socrata.violation_dataset_id, params[:page], {'$order': 'issued_date, case_number'})
  end

  def show
    socrata = Socrata.new
    @violation = socrata.client.get(socrata.violation_dataset_id, {'$where': "case_number = '#{params[:id]}'"}).first
  end

end

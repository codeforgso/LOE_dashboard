require File.expand_path(Rails.root)+'/lib/socrata'
class InspectionsController < ApplicationController

  def index
    @inspections = if params[:filters] and params[:filters][:case]
      Inspection.for_case(params[:filters][:case]).page params[:page]
    else
      Inspection.all.order('entry_date, case_number').page params[:page]
    end
  end

  def show
    @inspection = Rails.cache.fetch("inspections_show_#{params[:id]}}") do
      Inspection.find params[:id]
    end
  end

end

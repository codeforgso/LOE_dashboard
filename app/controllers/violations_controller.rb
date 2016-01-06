require File.expand_path(Rails.root)+'/lib/socrata'
class ViolationsController < ApplicationController

  def index
    @violations = if params[:filters] and params[:filters][:case]
      Violation.for_case(params[:filters][:case]).page params[:page]
    else
      Violation.all.order('entry_date, case_number').page params[:page]
    end
  end

  def show
    @violation = Rails.cache.fetch("violations_show_#{params[:id]}}") do
      Violation.find params[:id]
    end
  end


end

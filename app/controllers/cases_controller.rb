require File.expand_path(Rails.root)+'/lib/socrata'
class CasesController < ApplicationController

  def index
    @cases = LoeCase.all.order('entry_date, case_number').page params[:page]
  end

  def show
    @case = Rails.cache.fetch("cases_show_#{params[:id]}}") do
      LoeCase.find params[:id]
    end
  end

end

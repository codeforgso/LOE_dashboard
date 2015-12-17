require File.expand_path(Rails.root)+'/lib/socrata'
class CasesController < ApplicationController

  def index
    params[:page] ||= 1
    @cases = Rails.cache.fetch("cases_index_page_#{params[:page]}") do
      socrata = Socrata.new
      socrata.paginate(socrata.case_dataset_id, params[:page], {'$order': 'entry_date, case_number'})
    end
  end

  def show
    @case = Rails.cache.fetch("cases_show_#{params[:id]}}") do
      socrata = Socrata.new
      socrata.client.get(socrata.case_dataset_id, {'$where': "case_number = '#{params[:id]}'"}).first
    end
  end

end

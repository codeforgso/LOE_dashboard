require File.expand_path(Rails.root)+'/lib/socrata'
class CaseHistoriesController < ApplicationController

  def index
    params[:filters] ||= {}
    params[:page] ||= 1
    @case_histories = if params[:filters].present?
      live_index_results
    else
      cached_index_results
    end
  end

  def show
    @case_history = Rails.cache.fetch("case_histories_show_#{params[:id]}}") do
      socrata = Socrata.new
      case_number = params[:id].split('*').first
      case_history_sakey = params[:id].split('*')[1]
      opts = {
        '$where': "case_number = '#{case_number}' and case_history_sakey='#{case_history_sakey}'"
      }
      socrata.client.get(socrata.case_history_dataset_id, opts).first
    end
  end

  private

  def live_index_results
    socrata = Socrata.new
    params[:filters] ||= {}
    opts = {'$order': 'date, case_number'}
    if params[:filters][:case]
      opts['$where'] = "case_number = '#{params[:filters][:case]}'"
    end
    socrata.paginate(socrata.case_history_dataset_id, params[:page], opts)
  end

  def cached_index_results
    Rails.cache.fetch("case_histories_index_page-#{params[:page]}}") { live_index_results }
  end

end

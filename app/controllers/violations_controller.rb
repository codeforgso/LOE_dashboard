require File.expand_path(Rails.root)+'/lib/socrata'
class ViolationsController < ApplicationController

  def index
    params[:filters] ||= {}
    params[:page] ||= 1
    @violations = if params[:filters].present?
      live_index_results
    else
      cached_index_results
    end
  end

  def show
    @violation = Rails.cache.fetch("violations_show_#{params[:id]}}") do
      socrata = Socrata.new
      case_number = params[:id].split('*').first
      entry_date = params[:id].split('*')[1]
      violation_code = params[:id].split('*')[2]

      opts = {'$where' => "case_number = '#{case_number}'"}

      if entry_date and entry_date = entry_date.to_i and entry_date > 0
        opts['$where'] += " and entry_date = '#{Time.at(entry_date).strftime("%Y-%m-%dT%H:%M:%S")}'"
      end
      if violation_code and violation_code != ''
        opts['$where'] += " and violation_code = '#{violation_code}'"
      end
      socrata.client.get(socrata.violation_dataset_id, opts).first
    end
  end

  private

  def live_index_results
    socrata = Socrata.new
    opts = {'$order': 'issued_date, case_number'}
    if params[:filters][:case]
      opts['$where'] = "case_number = '#{params[:filters][:case]}'"
    end
    socrata.paginate(socrata.violation_dataset_id, params[:page], opts)
  end

  def cached_index_results
    Rails.cache.fetch("violations_index_page-#{params[:page]}}") { live_index_results }
  end

end

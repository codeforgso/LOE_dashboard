require File.expand_path(Rails.root)+'/lib/socrata'
class InspectionsController < ApplicationController

  def index
    params[:filters] ||= {}
    params[:page] ||= 1
    @inspections = if params[:filters].present?
      live_index_results
    else
      cached_index_results
    end
  end

  def show
    @inspection = Rails.cache.fetch("inspections_show_#{params[:id]}}") do
      case_number = params[:id].split('*').first
      entry_date = params[:id].split('*')[1]
      inspection_date = params[:id].split('*')[2]

      opts = {'$where' => "case_number = '#{case_number}'"}
      if entry_date and entry_date = entry_date.to_i and entry_date > 0
        opts['$where'] += " and entry_date = '#{Time.at(entry_date).strftime("%Y-%m-%dT%H:%M:%S")}'"
      end
      if inspection_date and inspection_date = inspection_date.to_i and inspection_date > 0
        opts['$where'] += " and inspection_date = '#{Time.at(inspection_date).strftime("%Y-%m-%dT%H:%M:%S")}'"
      end

      socrata = Socrata.new
      socrata.client.get(socrata.inspection_dataset_id, opts).first
    end
  end

  private

  def live_index_results
    socrata = Socrata.new
    opts = {'$order': 'inspection_date, case_number'}
    if params[:filters][:case]
      opts['$where'] = "case_number = '#{params[:filters][:case]}'"
    end
    socrata.paginate(socrata.inspection_dataset_id, params[:page], opts)
  end

  def cached_index_results
    Rails.cache.fetch("inspections_index_page-#{params[:page]}}") { live_index_results }
  end

end

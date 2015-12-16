require File.expand_path(Rails.root)+'/lib/socrata'
class InspectionsController < ApplicationController

  def index
    socrata = Socrata.new
    params[:filters] ||= {}
    opts = {'$order': 'inspection_date, case_number'}
    if params[:filters][:case]
      opts['$where'] = "case_number = '#{params[:filters][:case]}'"
    end
    @inspections = socrata.paginate(socrata.inspection_dataset_id, params[:page], opts)
  end

  def show
    socrata = Socrata.new
    case_number = params[:id].split('*').first
    entry_date = params[:id].split('*')[1]
    inspection_date = params[:id].split('*')[2]

    # For some reason, ruby won't let you do something like this:
    #  opts = {'$where': 'foo'}
    #  opts['$where'] += ' and bar'
    #
    # It gives a whiny nil error when you try the += command.
    # The workaround is to build a where clause string and add to
    # opts at the end.
    where = "case_number = '#{case_number}'"

    if entry_date and entry_date = entry_date.to_i and entry_date > 0
      where += " and entry_date = '#{Time.at(entry_date).strftime("%Y-%m-%dT%H:%M:%S")}'"
    end
    if inspection_date and inspection_date = inspection_date.to_i and inspection_date > 0
      where += " and inspection_date = '#{Time.at(inspection_date).strftime("%Y-%m-%dT%H:%M:%S")}'"
    end
    opts = {'$where': where}
    @inspection = socrata.client.get(socrata.inspection_dataset_id, opts).first
  end

end

require File.expand_path(Rails.root)+'/lib/socrata'
class CasesController < ApplicationController

  def index
    params[:filters] ||= {}
    sort = (valid_sorts && [params[:sort]]).first || 'entry_date'
    sort += " #{(['ASC', 'DESC'] && [params[:sort_dir]]).first}"
    @cases = LoeCase.filter(params[:filters].slice(*valid_filters))
      .order(sort)
      .select(select_for_index)
      .page params[:page]
  end

  def show
    @case = Rails.cache.fetch("cases_show_#{params[:id]}}") do
      LoeCase.where(id: params[:id]).eager_load(:violations, :inspections).first
    end
  end

  def autocomplete
    data = case params[:param].to_sym
    when :case_number
        where = ["RTRIM(LTRIM(TO_CHAR(#{params[:param]},'999999999')) ilike ?", params[:q]]
        LoeCase.where(where).order(params[:param])
        .select("distinct(#{params[:param]})").limit(8).map do |c|
          { name: c[params[:param]].to_s }
        end
    when :st_name, :full_address
      # where = LoeCase.arel_table[params[:param].to_sym].matches("#{params[:q]}%")
      where = ["#{params[:param]} ilike ?","#{params[:q]}%"]
      LoeCase.where(where).order(params[:param])
        .select("distinct(#{params[:param]})").limit(8).map do |c|
          { name: c[params[:param]].to_s }
        end    else
      []
    end
    render text: data.to_json
  end

  private

  def valid_filters
    [
      :case_number, :entry_date_range, :st_name, :full_address,
      :use_code
    ]
  end

  def valid_sorts
    [:entry_date, :case_number]
  end

  def select_for_index
    [:id, :case_number, :case_notes, :entry_date]
  end

end

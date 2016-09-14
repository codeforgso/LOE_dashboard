require File.expand_path(Rails.root)+'/lib/socrata'
class CasesController < ApplicationController

  def index
    params[:filters] ||= {}
    sort = (valid_sorts && [params[:sort]]).first || 'entry_date'
    sort += " #{(['ASC', 'DESC'] && [params[:sort_dir]]).first}"
    @cases = cases_for_index(params, sort)
  end

  def show
    @case = Rails.cache.fetch("cases_show_#{params[:case_number]}}") do
      LoeCase.where(case_number: params[:case_number]).eager_load(:violations, :inspections).first
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
    when :st_name, :full_address, :owner_name
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

  def cases_for_index(params, sort)
    params[:page] ||= 1
    Rails.cache.fetch("cases_index_#{Digest::SHA256.hexdigest(params[:filters].to_yaml)}}_#{params[:page]}_#{sort}") do
      # An Arel result is not cacheable.  We have to convert our results
      # to a paginated array so it will be cacheable.

      params[:page] = params[:page].to_i

      # array to fill with results for pagination:
      #    * need the actual items to show on page view
      #    * need to pad the array with nil values so it
      #      will render pagination links
      arr = []

      # pad the previous pages with nil values
      arr += Array.new([(params[:page] - 1) * Kaminari.config.default_per_page, 0].max)


      cases = LoeCase.filter(params[:filters].slice(*valid_filters))
        .order(sort)
        .select(select_for_index)
        .page(params[:page])
      # add the page being viewed to arr
      arr += cases.to_a

      # if there are more pages after the current one, add more nil values
      if cases.total_count > params[:page] * Kaminari.config.default_per_page
        arr += Array.new([cases.total_count - (params[:page] * Kaminari.config.default_per_page), 0].max)
      end

      # paginate
      Kaminari.paginate_array(arr).page(params[:page])
    end
  end

  def valid_filters
    [
      :case_number, :entry_date_range, :st_name, :full_address,
      :use_code, :owner_name, :rental_status, :case_type
    ]
  end

  def valid_sorts
    [:entry_date, :case_number]
  end

  def select_for_index
    [:id, :case_number, :case_notes, :entry_date]
  end

end

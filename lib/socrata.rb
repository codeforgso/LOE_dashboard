class Socrata
  CONFIG_FILE = File.expand_path(Rails.root)+"/config/socrata.yml"
  attr_reader :client

  def datasets
    settings["datasets"]
  end

  def inspection_dataset_id
    get_dataset_id_by_name 'LOE All Inspections'
  end

  def violation_dataset_id
    get_dataset_id_by_name 'LOE All Violations'
  end

  def case_dataset_id
    get_dataset_id_by_name 'LOE All Cases'
  end

  def case_history_dataset_id
    get_dataset_id_by_name 'LOE Case History'
  end

  def paginate(dataset_id,page)
    # make sure page is a Fixnum, but don't let nil
    # values get converted to zero.
    page ||= 1
    page = page.to_i

    # array to fill with results for pagination:
    #    * need the actual items to show on page view
    #    * need to pad the array with nil values so it
    #      will render pagination links
    arr = []

    # pad the previous pages with nil values
    arr += Array.new([(page - 1) * Kaminari.config.default_per_page, 0].max)

    # options for querying Socrata
    opts = {
      '$limit': Kaminari.config.default_per_page,
      '$order': 'inspection_date, case_number',
      '$offset': (page - 1) * Kaminari.config.default_per_page
    }

    # add the page being viewed to arr
    arr += client.get(dataset_id, opts)

    # if there are more pages after the current one, add more nil values
    total_record_count = client.get(dataset_id,{'$select': 'count(*)'})[0]['count'].to_i
    if total_record_count > page * Kaminari.config.default_per_page
      arr += Array.new([total_record_count - (page * Kaminari.config.default_per_page), 0].max)
    end

    # paginate
    Kaminari.paginate_array(arr).page(page)
  end

  private

  def initialize
    @client = SODA::Client.new({domain: settings["domain"], app_token: settings["app_token"]})
  end

  def settings
    require 'yaml'
    YAML::load(File.open(self.class::CONFIG_FILE).read)[Rails.env]
  end

  def get_dataset_id_by_name(name)
    datasets.each do |dataset|
      if dataset['name'] == name
        return dataset['id']
      end
    end
    nil
  end

end

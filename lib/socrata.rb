class Socrata
  CONFIG_FILE = File.expand_path(Rails.root)+"/config/socrata.yml"
  attr_reader :client

  def self.datasets
    settings["datasets"]
  end

  def self.inspection_dataset_id
    get_dataset_id_by_name 'LOE All Inspections'
  end

  def self.violation_dataset_id
    get_dataset_id_by_name 'LOE All Violations'
  end

  def self.case_dataset_id
    get_dataset_id_by_name 'LOE All Cases'
  end

  def self.case_history_dataset_id
    get_dataset_id_by_name 'LOE Case History'
  end

  def inspection_dataset_id
    self.class.inspection_dataset_id
  end

  def violation_dataset_id
    self.class.violation_dataset_id
  end

  def case_dataset_id
    self.class.case_dataset_id
  end

  def case_history_dataset_id
    self.class.case_history_dataset_id
  end

  def paginate(dataset_id,page,opts={})
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
    opts.merge({
      '$limit': Kaminari.config.default_per_page,
      '$offset': (page - 1) * Kaminari.config.default_per_page
    })

    # add the page being viewed to arr
    arr += client.get(dataset_id, opts)

    # if there are more pages after the current one, add more nil values
    opts2 = {'$select': 'count(*)'}
    if opts['$where']
      opts2['$where'] = opts['$where']
    end
    total_record_count = client.get(dataset_id, opts2)[0]['count'].to_i
    if total_record_count > page * Kaminari.config.default_per_page
      arr += Array.new([total_record_count - (page * Kaminari.config.default_per_page), 0].max)
    end

    # paginate
    Kaminari.paginate_array(arr).page(page)
  end

  def self.seed(klass,dataset_id,offset=nil,batch_mode=nil)
    # Socrata.seed Violation, Socrata.violation_dataset_id, Violation.count
    klass.delete_all unless offset
    batch_mode = true if batch_mode.nil?
    cache = {}
    if %w(Inspection Violation).include?(klass.to_s)
      LoeCase.select('id, case_number').each do |loe_case|
        cache[loe_case.case_number] = loe_case.id
      end
    end
    socrata = self.new
    total_record_count = socrata.client.get(dataset_id, {'$select' => 'count(*)'})[0]['count'].to_i || 0
    batch_size = 1000
    (total_record_count/batch_size.to_f).ceil.times do |n|
      opts = {
        '$limit' => batch_size,
        '$offset' => n * batch_size
      }
      skip = false
      if offset and offset.kind_of?(Fixnum)
        skip = opts['$offset'] > offset
      end
      unless skip
        items = []
        socrata.client.get(dataset_id,opts).each do |socrata_item|
          item = klass.new
          item.assign_from_socrata socrata_item, cache
          if batch_mode
            items << item
          else
            item.save
          end
          print "."
        end
        klass.import(items) if batch_mode
        print "*"
      end
    end
  end

  private

  def initialize
    @client = SODA::Client.new({domain: self.class.settings["domain"], app_token: self.class.settings["app_token"]})
  end

  def self.settings
    require 'yaml'
    YAML::load(ERB.new(File.open(CONFIG_FILE).read).result)[Rails.env]
  end

  def self.get_dataset_id_by_name(name)
    datasets.each do |dataset|
      if dataset['name'] == name
        return dataset['id']
      end
    end
    nil
  end

end

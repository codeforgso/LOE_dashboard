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

class Socrata
  CONFIG_FILE = File.expand_path(Rails.root)+"/config/socrata.yml"
  attr_reader :client

  def datasets
    settings["datasets"]
  end

  private

  def initialize
    @client = SODA::Client.new({domain: settings["domain"], app_token: settings["app_token"]})
  end

  def settings
    require 'yaml'
    YAML::load(File.open(self.class::CONFIG_FILE).read)[Rails.env]
  end

end

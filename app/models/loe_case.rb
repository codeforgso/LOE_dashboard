require File.expand_path(Rails.root)+'/lib/socrata'
class LoeCase < ActiveRecord::Base

  has_many :inspections, -> { order(:case_sakey) }

  def self.seed
    Socrata.seed self, Socrata.case_dataset_id
  end

  def assign_from_socrata(socrata_result)
    socrata_result.keys.each do |key|
      raise "undefined attribute: #{key}" unless self.class.column_names.include?(key)
      case key
      when "ad_sakey", "case_number"
        self[key.to_sym] = socrata_result[key].strip.to_i
      when "annex_date"
        val = socrata_result[key].strip.split(",")[0].strip
        if val.length==4
          val += "/01/01"
        end
        self[key.to_sym] = Date.parse val
        if self[key.to_sym] > Date.today
          self[key.to_sym] = self[key.to_sym].to_time.advance(years: -100).to_date
        end
      when "close_date", "due_date", "entry_date", "last_update"
        self[key.to_sym] = Time.parse(socrata_result[key].strip)
      else self[key.to_sym] = socrata_result[key].strip
      end
    end
  end

end

require File.expand_path(Rails.root)+'/lib/socrata'
class Violation < ActiveRecord::Base

  belongs_to :loe_case

  scope :for_case, -> (loe_case_id) { where(loe_case_id: loe_case_id).order('case_sakey') }

  def self.seed
    Socrata.seed self, Socrata.violation_dataset_id
  end

  def assign_from_socrata(socrata_result)
    socrata_result.keys.each do |key|
      raise "undefined attribute: #{key}\n#{socrata_result.to_json}" unless self.class.column_names.include?(key)
      unless socrata_result[key].strip == "NULL"
        case key
        when "case_sakey", "case_number", "violation_sakey", "number_of_items"
          self[key.to_sym] = socrata_result[key].strip.to_i
          if key == "case_number"
            self.loe_case_id = LoeCase.where('case_number = ?',self[key.to_sym]).limit(1).select('id').first.try(:id)
          end
        when "clear_date", "entry_date", "last_update", "issued_date", "reissue_date"
          begin
            if socrata_result[key].strip.match(/^\d+\/\d+\/\d+ \d+:\d+$/)
              self[key.to_sym] = Time.strptime(socrata_result[key].strip,"%m/%d/%Y %H:%M")
            else
              self[key.to_sym] = Time.parse(socrata_result[key].strip)
            end
          rescue ArgumentError => e
            puts "val: #{socrata_result[key].strip}"
            raise e
          end
        else self[key.to_sym] = socrata_result[key].strip
        end
      end
    end
  end

end

require File.expand_path(Rails.root)+'/lib/socrata'
class Violation < ActiveRecord::Base

  SOCRATA_ATTRIBUTE_REMAPPING = {
    "casenumber" => "case_number",
    "casesakey" => "case_sakey",
    "cleardate" => "clear_date",
    "clearedby" => "cleared_by",
    "entrydate" => "entry_date",
    "issuedby" => "issued_by",
    "issueddate" => "issued_date",
    "lastupdate" => "last_update",
    "majorviolation" => "major_violation",
    "numberofitems" => "number_of_items",
    "reissuedate" => "reissue_date",
    "reissuedby" => "reissued_by",
    "responsibleparty" => "responsible_party",
    "stapt" => "st_apt",
    "stname" => "st_name",
    "stnumber" => "st_number",
    "sttype" => "st_type",
    "violationcleared" => "violation_cleared",
    "violationcode" => "violation_code",
    "violationdescription" => "violation_description",
    "violationissued" => "violation_issued",
    "violationreissued" => "violation_reissued",
    "violationsakey" => "violation_sakey"
  }


  belongs_to :loe_case

  scope :for_case, -> (loe_case_id) { where(loe_case_id: loe_case_id).order('case_sakey') }

  def self.seed
    Socrata.seed self, Socrata.violation_dataset_id
  end

  def assign_from_socrata(socrata_result)
    socrata_result.keys.each do |key|
      col = self.class::SOCRATA_ATTRIBUTE_REMAPPING[key] || key
      raise "undefined attribute: #{key}\n#{socrata_result.to_json}" unless self.class.column_names.include?(col)
      unless socrata_result[key].strip == "NULL"
        case col.to_s
        when "case_sakey", "case_number", "violation_sakey", "number_of_items"
          self[col.to_sym] = socrata_result[key].strip.to_i
          if col == "case_number"
            self.loe_case_id = LoeCase.where('case_number = ?',self[col.to_sym]).limit(1).select('id').first.try(:id)
          end
        when "clear_date", "entry_date", "last_update", "issued_date", "reissue_date"
          begin
            if socrata_result[key].strip.match(/^\d+\/\d+\/\d+ \d+:\d+$/)
              self[col.to_sym] = Time.strptime(socrata_result[key].strip,"%m/%d/%Y %H:%M")
            else
              self[col.to_sym] = Time.parse(socrata_result[key].strip)
            end
          rescue ArgumentError => e
            puts "val: #{socrata_result[key].strip}"
            raise e
          end
        else self[col.to_sym] = socrata_result[key].strip
        end
      end
    end
  end

end

require File.expand_path(Rails.root)+'/lib/socrata'
class Inspection < ActiveRecord::Base

  SOCRATA_ATTRIBUTE_REMAPPING = {
    "casenumber" => "case_number",
    "casesakey" => "case_sakey",
    "entrydate" => "entry_date",
    "inspectiondate" => "inspection_date",
    "inspectionnotes" => "inspection_notes",
    "inspectionsakey" => "inspection_sakey",
    "inspectiontype" => "inspection_type",
    "inspectiontypedesc" => "inspection_type_desc",
    "lastupdate" => "last_update",
    "stapt" => "st_apt",
    "stname" => "st_name",
    "stnumber" => "st_number",
    "sttype" => "st_type",
    "inspectionid" => "inspection_id",
    "fulladdress" => "full_address",
    "xcoord" => "x_coord",
    "ycoord" => "y_coord",
    "adsakey" => "ad_sakey",
    "casetype" => "case_type",
    "casestatus" => "case_status"
  }


  belongs_to :loe_case

  scope :for_case, -> (loe_case_id) { where(loe_case_id: loe_case_id).order('case_sakey') }

  def self.seed
    Socrata.seed self, Socrata.inspection_dataset_id
  end

  def assign_from_socrata(socrata_result)
    socrata_result.keys.each do |key|
      col = self.class::SOCRATA_ATTRIBUTE_REMAPPING[key] || key
      raise "undefined attribute: #{key}\n#{socrata_result.to_json}" unless self.class.column_names.include?(col)
      unless socrata_result[key].strip == "NULL"
        case col.to_s
        when "case_sakey", "case_number", "inspection_sakey"
          self[col.to_sym] = socrata_result[key].strip.to_i
          if col == "case_number"
            self.loe_case_id = LoeCase.where('case_number = ?',self[col.to_sym]).limit(1).select('id').first.try(:id)

          end
        when "inspection_date", "entry_date", "last_update"
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

require File.expand_path(Rails.root)+'/lib/socrata'
class LoeCase < ActiveRecord::Base

  SOCRATA_ATTRIBUTE_REMAPPING = {
    "adlot" => "ad_lot",
    "adsakey" => "ad_sakey",
    "annexdate" => "annex_date",
    "assignedinspcode" => "assigned_inspector_code",
    "casenotes" => "case_notes",
    "casenumber" => "case_number",
    "casestatus" => "case_status",
    "casetype" => "case_type",
    "censustract" => "census_tract",
    "closedate" => "close_date",
    "closereason" => "close_reason",
    "duedate" => "due_date",
    "entrydate" => "entry_date",
    "fulladdress" => "full_address",
    "lastupdate" => "last_update",
    "ownermailcity" => "owner_mailcity",
    "ownermailstate" => "owner_mailstate",
    "ownermailaddr" => "owner_mailaddr",
    "ownermailaddr2" => "owner_mailaddr2",
    "ownermailzip" => "owner_mailzip",
    "ownername" => "owner_name",
    "ownername2" => "owner_name2",
    "rentalstatus" => "rental_status",
    "stapt" => "st_apt",
    "stname" => "st_name",
    "stnumber" => "st_number",
    "sttype" => "st_type",
    "usecode" => "use_code",
    "xcoord" => "x_coord",
    "ycoord" => "y_coord"
  }

  has_many :inspections, -> { order(:case_sakey) }
  has_many :violations, -> { order(:case_sakey) }

  def self.seed
    Socrata.seed self, Socrata.case_dataset_id
  end

  def assign_from_socrata(socrata_result)
    socrata_result.keys.each do |key|
      col = self.class::SOCRATA_ATTRIBUTE_REMAPPING[key] || key
      raise "undefined attribute: #{key}" unless self.class.column_names.include?(col)
      case col.to_s
      when "ad_sakey", "case_number"
        self[col.to_sym] = socrata_result[key].strip.to_i
      when "annex_date"
        val = socrata_result[key].strip.split(",")[0].strip
        if val.length==4
          val += "/01/01"
        end
        self[col.to_sym] = Date.parse val
        if self[col.to_sym] > Date.today
          self[col.to_sym] = self[col.to_sym].to_time.advance(years: -100).to_date
        end
      when "close_date", "due_date", "entry_date", "last_update"
        self[col.to_sym] = Time.parse(socrata_result[key].strip)
      when "x_coord", "y_coord"
        self[col.to_sym] = socrata_result[key].strip.to_f
      else self[col.to_sym] = socrata_result[key].strip
      end
    end
  end

end

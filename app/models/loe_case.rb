require File.expand_path(Rails.root)+'/lib/socrata'
class LoeCase < ActiveRecord::Base
  include Filterable

  SOCRATA_ATTRIBUTE_REMAPPING = {
    "adlot" => "ad_lot",
    "adsakey" => "ad_sakey",
    "annexdate" => "annex_date",
    "assignedinspcode" => "assigned_inspector_code",
    "casenotes" => "case_notes",
    "casenumber" => "case_number",
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
    "xcoord" => "x_coord",
    "ycoord" => "y_coord"
  }

  has_many :inspections, -> { order(:case_sakey) }
  has_many :violations, -> { order(:case_sakey) }
  belongs_to :case_status
  belongs_to :use_code

  scope :case_number, -> (case_number) { where case_number: case_number }
  scope :entry_date_range, -> (entry_date_range) do
    begin
      start_date = (!entry_date_range[:start_date].blank? and Date.parse(entry_date_range[:start_date])) || self.where(["entry_date is not ?",nil]).order(:entry_date).limit(1)[0].try(:entry_date).to_date
      end_date = (!entry_date_range[:end_date].blank? and Date.parse(entry_date_range[:end_date])) || Date.today
      where("entry_date >= ? and entry_date < ?", start_date.to_time, end_date.next.to_time)
    rescue
      none
    end
  end
  scope :entry_date, -> (entry_date) do
    begin
      if d = Date.parse(entry_date)
        where("entry_date >= ? and entry_date < ?", d.to_time, d.next.to_time)
      else
        none
      end
    rescue
      none
    end
  end
  scope :st_name, -> (st_name) { where st_name: st_name.try(:upcase) }
  scope :full_address, -> (full_address) { where('upper(full_address) = ?', full_address.try(:upcase)) }
  scope :open, -> { where case_status_id: CaseStatus.open.id }
  scope :closed, -> { where case_status_id: CaseStatus.closed.id }
  scope :use_code, -> (use_code) { where(use_code_id: use_code) }

  def self.seed
    Rails.cache.clear
    Socrata.seed self, Socrata.case_dataset_id
  end

  def assign_from_socrata(socrata_result)
    socrata_result.keys.each do |key|
      col = self.class::SOCRATA_ATTRIBUTE_REMAPPING[key] || key
      relations = {
        'casestatus' => CaseStatus,
        'usecode' => UseCode
      }
      if relations.keys.include?(col.to_s)
        opts = { name: socrata_result[key].strip }
        klass = relations[key]
        case klass.to_s
        when 'UseCode'
          opts[:name] = UseCode.remap_name opts[:name]
        end
        foreign_record = Rails.cache.fetch("#{klass}_name-#{opts[:name]}") do
          klass.where(opts).first || klass.create(opts)
        end
        self["#{klass.to_s.tableize.singularize}_id".to_sym] = foreign_record.id
      else
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

end

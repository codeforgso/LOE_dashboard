class UseCode < ActiveRecord::Base
  has_many :loe_cases
  validates :name, presence: true, uniqueness: true

  def self.remap_name(name)
    # some names are remapped on import from Socrata to avoid obvious duplicates
    case name
    when nil
      nil
    when /^\d+$/
      nil
    when /^COMME|Commercial$/
      'Commercial'
    when /^Encumbered/
      'Encumbered'
    when /^#{Regexp.escape('FUNERAL HOME-CEMETERY, MAUSELEUM')}|#{Regexp.escape('Funeral (Mortuaries, Cemeteries, Crematorium, Maus')}$/
      'Funeral (Mortuaries, Cemeteries, Crematorium, Mauseleum)'
    when /^Homes for the Aged/
      'Homes for the Aged'
    when /^INDUS/i
      'Industrial'
    when /^Insti/i
      'Institutional'
    when /^Office$/i
      'Office'
    when /^Singl/i
      'Single Family'
    else name.to_s.titleize
    end
  end
end

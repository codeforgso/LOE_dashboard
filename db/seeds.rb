# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

[LoeCase, Inspection, Violation].each do |klass|
  puts "\nseeding #{klass}..."
  klass.seed
  print "done"
end

puts "\nclearing cache..."
Rails.cache.clear
print "done"
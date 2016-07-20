namespace :loe do
  desc 'Seed database from Socrata API'
  task seed: :environment do
    [LoeCase, Inspection, Violation].each do |klass|
      puts "\nseeding #{klass}..."
      klass.seed
      print "done"
    end

    puts "\nclearing cache..."
    Rails.cache.clear
    print "done"
  end

  desc 'Identify database columns that only contain nil values'
  task find_nils: :environment do
    results = {}
    [LoeCase, Inspection, Violation].each do |klass|
      key = klass.to_s.downcase.to_sym
      print "\nInspecting `#{klass}` (#{klass.table_name} table)..."
      klass.column_names.sort.each do |col|
        sql = "SELECT COUNT(*) AS cnt FROM #{klass.table_name} WHERE #{col} IS NOT NULL"
        result = klass.connection.execute(sql)
        unless result.field_values('cnt').first.to_i > 0
          results[key] ||= []
          results[key] << col
        end
      end
      print "done\n"
    end
    require 'yaml'
    puts "\n" + results.to_yaml
  end
end

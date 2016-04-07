# from: https://gist.github.com/tcaddy/4348855
require 'rspec/core/rake_task'
orm_setting = Rails.configuration.generators.options[:rails][:orm]
spec_prereq =
  if (orm_setting == :active_record)
    Rails.configuration.active_record[:schema_format] == :sql ? 'db:test:clone_structure' : 'db:test:prepare'
  else
    :noop
  end
namespace :spec do
  [:requests, :models, :controllers, :views, :helpers, :mailers, :lib, :routing, :libs].each do |sub|
    dn = "#{File.expand_path(::Rails.root.to_s)}/spec/#{sub}"
    if File.exist?(dn) && File.directory?(dn)
      sub_files = Dir.open(dn).map { |fn| fn unless ['.', '..'].include?(fn) }.compact
      namespace sub.to_s.singularize.to_sym do
        (sub_files.map do |fn|
          unless File.exist?("#{dn}/#{fn}") && File.directory?("#{dn}/#{fn}")
            if File.extname(fn) == '.rb' && File.basename(fn, '.rb').match(/\w+(_spec?)/)
              File.basename(fn, '.rb').chomp('_spec')
            end
          end
        end).flatten.compact.sort.each do |spec|
          desc "Run the code examples in spec/#{sub}/#{spec}_spec.rb"
          RSpec::Core::RakeTask.new(spec.gsub(/(_routing|_controller|_helper)$/, '') => spec_prereq) do |t|
            t.pattern = "./spec/#{sub}/#{spec}_spec.rb"
          end
        end
        sub_files.each do |fn|
          if File.exist?("#{dn}/#{fn}") && File.directory?("#{dn}/#{fn}")
            sub_sub_files = (Dir.open("#{dn}/#{fn}").map do |sub_fn|
              if File.extname(sub_fn) == '.rb' && File.basename(sub_fn, '.rb').match(/\w+(_spec?)/)
                File.basename(sub_fn, '.rb').chomp('_spec')
              end
            end).flatten.compact.sort
            if sub_sub_files.size > 0
              desc "Run the code examples in spec/#{sub}/#{fn}"
              RSpec::Core::RakeTask.new(fn => spec_prereq) do |t|
                t.pattern = "./spec/#{sub}/#{fn}/*_spec.rb"
              end
            end
            namespace fn.to_s.singularize.to_sym do
              sub_sub_files.each do |spec|
                desc "Run the code examples in spec/#{sub}/#{fn}/#{spec}_spec.rb"
                RSpec::Core::RakeTask.new(spec.split('.')[0] => spec_prereq) do |t|
                  t.pattern = "./spec/#{sub}/#{fn}/#{spec}_spec.rb"
                end
              end
            end
          end
        end
      end
    end
  end
end

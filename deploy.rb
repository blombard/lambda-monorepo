require 'yaml'
require 'json'

filters = YAML.load_file('./.github/filters.yml')
processes = JSON.parse(ARGV[0])

processes.each do |key, value|
  system("sh deploy.sh #{key} #{filters[key][0].split('*')[0]}") if value.eql?('true')
end

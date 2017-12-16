#!/bin/env ruby

### Small ruby script to convert yaml to json
### ex.: ./yaml_to_json.rb savefile.yml savefile.json

require 'yaml'
require 'json'

def gen_json_from_yaml yaml_in, json_out
	msgs = []

	unless (File.exists?(yaml_in))
		msgs << "File #{yaml_in} doesn't exist."
		return msgs.join("\n")
	end

	msgs << "Generating #{json_out} JSON file from #{yaml_in} YAML file."
	yml = YAML.load_file yaml_in
	json = yml.to_json
	file = File.new json_out, "w"
	file.write json
	file.close
	return msgs.join("\n")
end

=begin
ret = convert ARGV[0], ARGV[1]
case ret
when 0
	puts "Done"
when 1
	puts "Error"
end
=end


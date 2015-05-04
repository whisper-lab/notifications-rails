#!/usr/bin/ruby

method = ARGV[0]    # "POST"
path = ARGV[1]      # "/api/users/2"
json = ARGV[2]      # '{"user":{"lng":"1"}}'
token = "l@whisperlab.com:4GxyW_RF7aSySxtLsZcm2bffj6srZj5Szg" # "l@whisperlab.com:4GxyW_RF7aSySxtLsZcm2bffj6srZj5Szg"

if method.nil? || path.nil? || json.nil?
  puts "Usage:"
  puts "./script_name method path json"
  exit
end
out = `curl --request #{method} http://localhost:3000#{path} -H 'Content-Type: application/json' -H 'Authorization: Token token="#{token}"' -d '#{json}' -v`

puts out

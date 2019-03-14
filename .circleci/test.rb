require 'safe_pretty_json'
raise 'error' if SafePrettyJson::VERSION.nil?
raise 'error' unless SafePrettyJson.prettify('{"a":1}') == "{\n  \"a\": 1\n}"

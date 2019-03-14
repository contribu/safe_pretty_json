# frozen_string_literal: true

require 'benchmark'
require 'json'
require 'safe_pretty_json'

def simple_prettify(json_str)
  JSON.pretty_generate(JSON.parse(json_str))
end

input = JSON.generate(
  a: {
    b: {
      c: {
        d: [1, 2, 3],
        e: 'abc',
        f: 1.1111111111111111111111111111111111111111111
      }
    }
  }
)

iter = 1_000_000

Benchmark.bm 10 do |r|
  r.report 'simple' do
    iter.times do
      simple_prettify(input)
    end
  end
  r.report 'safe_pretty_json' do
    iter.times do
      SafePrettyJson.prettify(input)
    end
  end
end

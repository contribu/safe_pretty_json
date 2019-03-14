# frozen_string_literal: true

require 'json'

RSpec.describe SafePrettyJson do
  it 'has a version number' do
    expect(SafePrettyJson::VERSION).not_to be nil
  end

  describe 'prettify' do
    describe 'without floating point' do
      [
        {},
        [],
        { a: 1 },
        { a: [1, 2, 3] },
        { a: 1, c: 3, b: 2 },
        { a: '{' },
        { a: '[' },
        { a: '}' },
        { a: ']' },
        { a: '"' },
        { a: '\\' }
      ].each do |input|
        describe 'compact' do
          input_json = JSON.generate(input)
          it input_json do
            expect(SafePrettyJson.prettify(input_json)).to eq(JSON.pretty_generate(input))
          end
        end

        describe 'pretty' do
          input_json = JSON.pretty_generate(input)
          it input_json do
            expect(SafePrettyJson.prettify(input_json)).to eq(JSON.pretty_generate(input))
          end
        end
      end
    end

    describe 'with floating point' do
      [
        [
          '{ "a": 1.111111111111111111111111111111111111111111111111111111 }',
          "{\n  \"a\": 1.111111111111111111111111111111111111111111111111111111\n}"
        ]
      ].each do |input, output|
        it input do
          expect(SafePrettyJson.prettify(input)).to eq(output)
        end
      end
    end
  end
end

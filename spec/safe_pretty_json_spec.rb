# frozen_string_literal: true

require 'json'

RSpec.describe SafePrettyJson do
  it 'has a version number' do
    expect(SafePrettyJson::VERSION).not_to be nil
  end

  describe 'prettify' do
    describe 'various' do
      [
        {},
        [],
        { a: 1 },
        { a: [1, 2, 3] },
        { a: 1, c: 3, b: 2 },
        { a: { b: { c: ['abc', { d: 4 }, [], [{}]] } } },
        { a: '{' },
        { a: '[' },
        { a: '}' },
        { a: ']' },
        { a: '"' },
        { a: '\\' },
        { a: ',' },
        { a: ' ' },
        { a: 'large' * 1_000_000 }
      ].each do |input|
        describe 'compact' do
          input_json = JSON.generate(input)
          it input_json[0..99] do
            expect(SafePrettyJson.prettify(input_json)).to eq(JSON.pretty_generate(input))
          end
        end

        describe 'pretty' do
          input_json = JSON.pretty_generate(input)
          it input_json[0..99] do
            expect(SafePrettyJson.prettify(input_json)).to eq(JSON.pretty_generate(input))
          end
        end
      end
    end

    describe 'floating point' do
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

    describe 'contains space' do
      [
        [
          "{ \"a\": \f\n\r\t\v1 }",
          "{\n  \"a\": 1\n}"
        ],
        [
          ' { "a": 1 }',
          "{\n  \"a\": 1\n}"
        ],
        [
          '{ "a": 1 } ',
          "{\n  \"a\": 1\n}"
        ]
      ].each do |input, output|
        it input do
          expect(SafePrettyJson.prettify(input)).to eq(output)
        end
      end
    end

    describe 'nil' do
      it 'raise TypeError' do
        expect { SafePrettyJson.prettify(nil) }.to raise_error(TypeError)
      end
    end

    describe 'integer' do
      it 'raise TypeError' do
        expect { SafePrettyJson.prettify(1) }.to raise_error(TypeError)
      end
    end

    describe 'empty string' do
      it 'returns empty string' do
        expect(SafePrettyJson.prettify('')).to eq('')
      end
    end

    describe 'instance supporting to_str' do
      it 'process result of to_str' do
        json_str = Struct.new('Test', :to_str).new('{}')
        expect(SafePrettyJson.prettify(json_str)).to eq(JSON.pretty_generate({}))
      end
    end

    describe 'string containing nil' do
      it 'raise ArgumentError' do
        json_str = ['{}'.unpack('c*'), 0, 'garbage'.unpack('c*')].flatten.pack('c*')
        expect { SafePrettyJson.prettify(json_str) }.to raise_error(ArgumentError)
      end
    end
  end
end

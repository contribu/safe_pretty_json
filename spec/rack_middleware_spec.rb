# frozen_string_literal: true

require 'json'

RSpec.describe SafePrettyJson::RackMiddleware do
  describe 'call' do
    describe 'not application/json' do
      it 'not prettify response' do
        response = Struct.new('Response', :body).new('{"a":1}')
        app = ->(_env) { ['a', { 'Content-Type' => 'text/plain' }, response] }
        status, headers, response = SafePrettyJson::RackMiddleware.new(app).call(nil)
        expect(status).to eq('a')
        expect(headers).to eq('Content-Type' => 'text/plain')
        expect(response).to eq(response)
      end
    end

    describe 'application/json' do
      it 'prettify response and set Content-Length' do
        response = Struct.new('Response', :body).new('{"a":1}')
        app = ->(_env) { ['a', { 'Content-Type' => 'application/json' }, response] }
        status, headers, response = SafePrettyJson::RackMiddleware.new(app).call(nil)
        expect(status).to eq('a')
        expected_response = "{\n  \"a\": 1\n}"
        expect(headers).to eq('Content-Length' => expected_response.length.to_s, 'Content-Type' => 'application/json')
        expect(response).to eq([expected_response])
      end
    end
  end
end

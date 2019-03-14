# frozen_string_literal: true

module SafePrettyJson
  class RackMiddleware
    def initialize(app)
      @app = app
    end

    def call(env)
      status, headers, response = @app.call(env)
      if %r{^application\/json}.match?(headers['Content-Type'])
        prettified = SafePrettyJson.prettify(response.body)
        response = [prettified]
        headers['Content-Length'] = prettified.bytesize.to_s
      end
      [status, headers, response]
    end
  end
end

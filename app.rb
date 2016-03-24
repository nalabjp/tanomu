require 'json'
require 'sinatra/base'
require './app/models/webhook'

class App < Sinatra::Base
  post "/#{ENV['TOKEN']}" do
    Webhook.run(event_type: request.env['HTTP_X_GITHUB_EVENT'], payload: payload)
    [204]
  end

  private

  def payload
    JSON.parse(request.body.read)
  rescue JSON::ParserError
    {}
  end
end

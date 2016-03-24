require 'json'
require 'sinatra/base'
require 'rack/github_webhooks'
require './app/models/webhook'

class App < Sinatra::Base
  use Rack::GithubWebhooks, secret: ENV['SECRET'] if ENV['SECRET'].nil?

  post '/' do
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

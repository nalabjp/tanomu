require './app/models/github/issue_comment'
require './app/models/github/pull_request'

class Webhook
  class << self
    def run(event_type: , payload:)
      return if event_type.nil?

      event = event_class(event_type)
      event.hook(payload: payload)
    rescue NameError => e
      raise unless e.message =~ /uninitialized constant/
    end

    private

    def event_class(event_type)
      Github.const_get event_type.split(/_/).map(&:capitalize).join
    end
  end
end

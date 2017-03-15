require './app/models/config'
require './app/models/events/base'

module Events
  class IssueComment < Events::Base
    attr_reader :payload

    def initialize(payload:)
      @payload = payload
    end

    def hook
      return unless payload
      return unless team_name
      return unless new_assignees

      update_pull_request
    end

    private

    def team_name
      team_name_by_phrase(comment)
    end

    def comment
      @comment ||= payload.dig('comment', 'body')
    end

    def assignee
      payload.dig('issue', 'assignee', 'login')
    end

    def creator
      payload.dig('issue', 'user', 'login')
    end

    def pull_request_number
      payload.dig('issue', 'number')
    end

    def new_assignees_size
      Integer(Config["#{team_name}.issue.assignees"])
    rescue TypeError, ArgumentError
      1
    end
  end
end

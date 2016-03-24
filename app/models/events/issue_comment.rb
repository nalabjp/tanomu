require './app/models/events/base'

module Events
  class IssueComment < Events::Base
    attr_reader :payload

    def initialize(payload:)
      @payload = payload
      @team_name = nil
    end

    def hook
      return unless payload
      return unless team_name
      return unless new_assignee

      client.update_issue("#{organization_name}/#{repository_name}", pull_request_number, assignee: new_assignee)
    end

    private

    def team_name
      return @team_name if @team_name

      assign_phrase = ENV.fetch('ASSIGN_PHRASE') # Please assign %team
      assign_phrase_pattern = Regexp.new(assign_phrase.sub('%team', '(?<team_name>.+)'))
      @team_name = comment.match(assign_phrase_pattern)&.[](:team_name)
    end

    def comment
      @comment ||= payload.dig('comment', 'body')
    end

    def assignee
      payload.dig('issue', 'assignee', 'login')
    end

    def repository_name
      payload.dig('issue', 'repository', 'name')
    end

    def organization_name
      payload.dig('issue', 'repository', 'full_name')&.split('/')&.first
    end

    def creator
      payload.dig('issue', 'user', 'login')
    end

    def pull_request_number
      payload.dig('issue', 'number')
    end
  end
end

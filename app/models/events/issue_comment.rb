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
      return unless new_assignee

      client.update_issue("#{organization_name}/#{repository_name}", pull_request_number, assignee: new_assignee)
    end

    private

    def team_name
      return @team_name unless @team_name.nil?

      assign_phrase = ENV.fetch('ASSIGN_PHRASE') # Please assign %team
      assign_phrase_pattern = Regexp.new(assign_phrase.sub('%team', '(?<team_name>.+)'))
      @team_name = comment.match(assign_phrase_pattern)&.[](:team_name)
    end

    def comment
      @comment ||= payload.dig('comment', 'body')
    end
  end
end

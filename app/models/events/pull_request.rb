require './app/models/events/base'

module Events
  class PullRequest < Events::Base
    attr_reader :payload

    def initialize(payload:)
      @payload = payload
    end

    def hook
      return unless payload
      return if payload['action'] == 'unassigned'
      return if wip?
      return if assignee
      return unless team_name
      return unless new_assignee

      update_pull_request
    end

    private

    def team_name
      team_name_by_phrase(payload.dig('pull_request', 'body')) || repository_name
    end

    def wip?
      payload.dig('pull_request', 'title') =~ /\A(?:WIP|\(WIP\)|\[WIP\])/i
    end

    def new_assignee
      candidates.sample
    end

    def assignee
      payload.dig('pull_request', 'assignee', 'login')
    end

    def creator
      payload.dig('pull_request', 'user', 'login')
    end

    def pull_request_number
      payload.dig('pull_request', 'number')
    end
  end
end

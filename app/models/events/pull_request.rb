require './app/models/events/base'

module Events
  class PullRequest < Events::Base
    attr_reader :payload

    def initialize(payload:)
      @payload = payload
    end

    def hook
      return unless payload
      return if assignee
      return unless team_name
      return unless new_assignee

      update_pull_request
    end

    private
    def new_assignee
      candidates.sample
    end

    def assignee
      payload.dig('pull_request', 'assignee', 'login')
    end

    def repository_name
      payload.dig('pull_request', 'repository', 'name')
    end
    alias_method :team_name, :repository_name

    def organization_name
      payload.dig('pull_request', 'repository', 'full_name')&.split('/')&.first
    end

    def creator
      payload.dig('pull_request', 'user', 'login')
    end

    def pull_request_number
      payload.dig('pull_request', 'number')
    end
  end
end

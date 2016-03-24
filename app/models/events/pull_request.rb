require 'octokit'

module Events
  class PullRequest
    attr_reader :payload

    def initialize(payload:)
      @payload = payload
    end

    def hook
      return if payload.nil?
      return unless assignee.nil?
      return unless new_assignee

      client.update_issue("#{organization_name}/#{repository_name}", pull_request_number, assignee: new_assignee)
    end

    private

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

    def client
      @client ||= Octokit::Client.new(access_token: ENV.fetch('GITHUB_API_TOKEN'))
    end

    def team
      @team ||= client.organization_teams(organization_name, { per_page: 100 }).find { |t| t['name'] == team_name }
    end

    def candidates
      @candidates ||= client.team_members(team.id, { per_page: 100 }).map(&:login) - [creator]
    end

    def new_assignee
      candidates.sample
    end
  end
end

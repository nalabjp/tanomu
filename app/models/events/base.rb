require 'octokit'

module Events
  class Base
    private

    def update_pull_request
      client.update_issue("#{organization_name}/#{repository_name}", pull_request_number, assignees: new_assignees)
    rescue Octokit::NotFound
      puts "Does #{team_name} have 'write' permission?"
    end

    def client
      @client ||= Octokit::Client.new(access_token: ENV.fetch('GITHUB_API_TOKEN'))
    end

    def team
      @team ||= client.organization_teams(organization_name, { per_page: 100 })&.find { |t| t['name'] == team_name }
    end

    def candidates
      @candidates ||= client.team_members(team.id, { per_page: 100 }).map(&:login) - [creator]
    end

    def new_assignees
      Array(candidates.sample(new_assignees_size)).sort
    end

    def repository_name
      payload.dig('repository', 'name')
    end

    def organization_name
      payload.dig('repository', 'full_name')&.split('/')&.first
    end

    def team_name_by_phrase(content)
      return @team_name if @team_name ||= nil

      assign_phrase = ENV.fetch('ASSIGN_PHRASE') # Please assign %team
      assign_phrase_pattern = Regexp.new(assign_phrase.sub('%team', '(?<team_name>.+)'))
      @team_name = content&.match(assign_phrase_pattern)&.[](:team_name)
    end

    def new_assignees_size
      1
    end
  end
end

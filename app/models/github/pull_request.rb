module Github
  class PullRequest
    class << self
      def hook(payload:)
        return if payload.nil?

        assignee = payload.dig('pull_request', 'assignee', 'login')
        return if assignee.nil?

        # TODO
        # repository名を取得
        # team名を取得
        # team_idを取得
        # membersを取得
        # randomに選出
        # prに対してassign
      end
    end
  end
end

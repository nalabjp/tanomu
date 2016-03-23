module Github
  class IssueComment
    class << self
      def hook(payload:)
        return if payload.nil?

        comment = payload.dig('comment', 'body')

        # TODO
        # commentからteamパターンを取得
        # team名を取得
        # team_idを取得
        # membersを取得
        # randomに選出
        # prに対してassign
      end
    end
  end
end

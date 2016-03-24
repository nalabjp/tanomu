require File.expand_path '../../../test_helper.rb', __FILE__

class Github::IssueCommentTest < MiniTest::Test
  def test_hook
    Github::PullRequest.new(payload: nil).hook
  end
end

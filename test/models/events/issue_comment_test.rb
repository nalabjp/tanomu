require File.expand_path '../../../test_helper.rb', __FILE__

class Events::IssueCommentTest < MiniTest::Test
  def test_hook
    Events::PullRequest.new(payload: nil).hook
  end
end

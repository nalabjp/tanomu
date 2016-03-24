require File.expand_path '../../../test_helper.rb', __FILE__

class Github::PullRequestTest < MiniTest::Test
  def test_hook
    payload = {
      'pull_request' => {
        'number' => 1,
        'assignee' => nil,
        'user' => {
          'login' => 'ppworks'
        },
        'repository' => {
          'name' => 'sandbox',
          'full_name' => 'genuineblue/sandbox'
        }
      }
    }

    client = mock('Octokit::Client')
    client.expects(:organization_teams).returns([OpenStruct.new(name: 'sandbox', id: 12345)])
    client.expects(:team_members).returns([OpenStruct.new(login: 'ppworks'), OpenStruct.new(login: 'ppworks2')])
    client.expects(:update_issue).with('genuineblue/sandbox', 1, assignee: 'ppworks2')
    Octokit::Client.expects(:new).with(access_token: ENV.fetch('GITHUB_API_TOKEN')).returns(client)

    Github::PullRequest.new(payload: payload).hook
  end
end

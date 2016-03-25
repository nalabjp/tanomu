require File.expand_path '../../../test_helper.rb', __FILE__

class Events::PullRequestTest < MiniTest::Test
  def test_hook
    payload = {
      'pull_request' => {
        'title' => 'Pull request',
        'number' => 1,
        'assignee' => nil,
        'user' => {
          'login' => 'ppworks'
        }
      },
      'repository' => {
        'name' => 'sandbox',
        'full_name' => 'genuineblue/sandbox'
      }
    }

    client = mock('Octokit::Client')
    client.expects(:organization_teams).returns([OpenStruct.new(name: 'sandbox', id: 12345)])
    client.expects(:team_members).with(12345, { per_page: 100 }).returns([OpenStruct.new(login: 'ppworks'), OpenStruct.new(login: 'ppworks2')])
    client.expects(:update_issue).with('genuineblue/sandbox', 1, assignee: 'ppworks2')
    Octokit::Client.expects(:new).with(access_token: ENV.fetch('GITHUB_API_TOKEN')).returns(client)

    Events::PullRequest.new(payload: payload).hook
  end

  def test_hook_by_pull_request_body
    payload = {
      'pull_request' => {
        'title' => 'Pull request',
        'number' => 1,
        'assignee' => nil,
        'user' => {
          'login' => 'ppworks'
        },
        'body' => 'tech_teamをアサインして'
      },
      'repository' => {
        'name' => 'sandbox',
        'full_name' => 'genuineblue/sandbox'
      }
    }

    client = mock('Octokit::Client')
    client.expects(:organization_teams).returns([OpenStruct.new(name: 'sandbox', id: 12345), OpenStruct.new(name: 'tech_team', id: 12346)])
    client.expects(:team_members).with(12346, { per_page: 100 }).returns([OpenStruct.new(login: 'ppworks'), OpenStruct.new(login: 'ppworks3')])
    client.expects(:update_issue).with('genuineblue/sandbox', 1, assignee: 'ppworks3')
    Octokit::Client.expects(:new).with(access_token: ENV.fetch('GITHUB_API_TOKEN')).returns(client)

    Events::PullRequest.new(payload: payload).hook
  end

  def test_wip_hook
    payload = {
      'pull_request' => {
        'title' => '[WIP] Pull request',
        'number' => 1,
        'assignee' => nil,
        'user' => {
          'login' => 'ppworks'
        }
      },
      'repository' => {
        'name' => 'sandbox',
        'full_name' => 'genuineblue/sandbox'
      }
    }

    Octokit::Client.expects(:new).with(access_token: ENV.fetch('GITHUB_API_TOKEN')).never

    Events::PullRequest.new(payload: payload).hook
  end
end

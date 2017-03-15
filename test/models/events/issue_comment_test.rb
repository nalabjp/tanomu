require File.expand_path '../../../test_helper.rb', __FILE__

class Events::IssueCommentTest < MiniTest::Test
  def test_hook
    payload = {
      'issue' => {
        'number' => 1,
        'assignee' => nil,
        'user' => {
          'login' => 'ppworks'
        }
      },
      'repository' => {
        'name' => 'sandbox',
        'full_name' => 'genuineblue/sandbox'
      },
      'comment' => {
        'body' => 'tech_teamをアサインして'
      }
    }

    client = mock('Octokit::Client')
    client.expects(:organization_teams).returns([OpenStruct.new(name: 'sandbox', id: 12345), OpenStruct.new(name: 'tech_team', id: 12346)])
    client.expects(:team_members).with(12346, { per_page: 100 }).returns([OpenStruct.new(login: 'ppworks'), OpenStruct.new(login: 'ppworks3')])
    client.expects(:update_issue).with('genuineblue/sandbox', 1, assignees: ['ppworks3'])
    Octokit::Client.expects(:new).with(access_token: ENV.fetch('GITHUB_API_TOKEN')).returns(client)

    Events::IssueComment.new(payload: payload).hook
  end

  def test_hook_with_multiple_assignees
    payload = {
      'issue' => {
        'number' => 1,
        'assignee' => nil,
        'user' => {
          'login' => 'ppworks'
        }
      },
      'repository' => {
        'name' => 'sandbox',
        'full_name' => 'genuineblue/sandbox'
      },
      'comment' => {
        'body' => 'tech_teamをアサインして'
      }
    }

    client = mock('Octokit::Client')
    client.expects(:organization_teams).returns([OpenStruct.new(name: 'sandbox', id: 12345), OpenStruct.new(name: 'tech_team', id: 12346)])
    client.expects(:team_members).with(12346, { per_page: 100 }).returns([OpenStruct.new(login: 'ppworks'), OpenStruct.new(login: 'ppworks3'), OpenStruct.new(login: 'nalabjp')])
    client.expects(:update_issue).with('genuineblue/sandbox', 1, assignees: ['nalabjp', 'ppworks3'])
    Octokit::Client.expects(:new).with(access_token: ENV.fetch('GITHUB_API_TOKEN')).returns(client)
    Config.expects(:[]).with("tech_team.issue.assignees").at_least_once.returns(2)

    Events::IssueComment.new(payload: payload).hook
  end
end

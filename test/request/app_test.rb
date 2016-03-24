require File.expand_path '../../test_helper.rb', __FILE__

class AppTest < MiniTest::Test
  include Rack::Test::Methods

  def app
    App
  end

  def test_get
    get '/token'
    assert_equal 404, last_response.status
    assert_match 'Not Found', last_response.body
  end

  def test_post_with_correct_token
    Webhook.expects(:run).with(event_type: nil, payload: {})

    post '/'
    assert_equal 204, last_response.status
    assert_equal '', last_response.body
  end

  def test_post_with_correct_token_with_params
    Webhook.expects(:run).with(event_type: 'issue_comment', payload: { 'issue' => { 'comment' => 'content' } })

    post '/', '{"issue":{"comment":"content"}}', { 'HTTP_X_GITHUB_EVENT' => 'issue_comment' }
    assert_equal 204, last_response.status
    assert_equal '', last_response.body
  end
end

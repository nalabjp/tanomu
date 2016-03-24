require File.expand_path '../../test_helper.rb', __FILE__

class AppTest < MiniTest::Test
  include Rack::Test::Methods

  def app
    App
  end

  def signature(body)
    'sha1=' + OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha1'), ENV['SECRET_TOKEN'], body)
  end

  def test_get
    get '/token', {}, { 'HTTP_X_HUB_SIGNATURE' => signature('') }
    assert_equal 404, last_response.status
    assert_match 'Not Found', last_response.body
  end

  def test_post_with_wrong_token
    post '/invalid_token', {}, { 'HTTP_X_HUB_SIGNATURE' => signature('') }
    assert_equal 404, last_response.status
    assert_match 'Not Found', last_response.body
  end

  def test_post_with_correct_token
    Webhook.expects(:run).with(event_type: nil, payload: {})

    post '/token', {}, { 'HTTP_X_HUB_SIGNATURE' => signature('') }
    assert_equal 204, last_response.status
    assert_equal '', last_response.body
  end

  def test_post_with_correct_token_with_params
    Webhook.expects(:run).with(event_type: 'issue_comment', payload: { 'issue' => { 'comment' => 'content' } })

    body = '{"issue":{"comment":"content"}}'
    post '/token', body, { 'HTTP_X_HUB_SIGNATURE' => signature(body), 'HTTP_X_GITHUB_EVENT' => 'issue_comment' }
    assert_equal 204, last_response.status
    assert_equal '', last_response.body
  end
end

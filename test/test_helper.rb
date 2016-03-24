ENV['RACK_ENV'] = 'test'
ENV['SECRET_TOKEN'] = 'secret'
ENV['TOKEN'] = 'token'
ENV['GITHUB_API_TOKEN'] = 'github_api_token'
ENV['ASSIGN_PHRASE'] = '%teamをアサイン'
require 'minitest/autorun'
require 'rack/test'
require 'mocha/mini_test'

require File.expand_path '../../app.rb', __FILE__

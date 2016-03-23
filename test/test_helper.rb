ENV['RACK_ENV'] = 'test'
ENV['TOKEN'] = 'token'
require 'minitest/autorun'
require 'rack/test'
require 'mocha/mini_test'

require File.expand_path '../../app.rb', __FILE__

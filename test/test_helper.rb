ENV['RAILS_ENV'] ||= 'test'
require_relative "../config/environment"
require "rails/test_help"

require 'minitest/mock'

require 'webmock/minitest'
WebMock.disable_net_connect!(allow_localhost: true, allow: Webdrivers::Common.subclasses.map(&:base_url))
# ☝️ webdrivers makes actual http requests to ensure you've got the right selenium dirvers. we've
# gotta make sure it can still do that, even though we blocked http traffic with webmock.
#
# refs: https://github.com/titusfortner/webdrivers/wiki/Using-with-VCR-or-WebMock
#       https://github.com/Betterment/webvalve/blob/master/lib/webvalve/monkey_patches.rb

require File.join(Rails.root, 'test/test_helpers/fakes/finnhub/api.rb')

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
end

class ActionDispatch::IntegrationTest
  def sign_in_as(user, password: 'password')
    post sessions_path, params: { session: { username: user.username, password: password } }
  end

  def assert_requires_user
    assert_equal 'You must be signed in to access this page', flash[:warning]
    assert_redirected_to new_session_path
  end

  def flash
    Stonky::TestFlashDelegatorThatKnowsAboutRenderedMessages.new(super, self)
  end
end

module Stonky
  class TestFlashDelegatorThatKnowsAboutRenderedMessages < Delegator
    attr_accessor :__flash__, :__test_context__
    alias_method :__getobj__, :__flash__

    def initialize(flash, test_context)
      self.__flash__ = flash
      self.__test_context__ = test_context
    end

    def rendered
      __test_context__.css_select("#flash_messages_container div[role=\"alert\"] > p").collect(&:text)
    end
  end
end

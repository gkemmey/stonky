ENV['RAILS_ENV'] ||= 'test'
require_relative "../config/environment"
require "rails/test_help"

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

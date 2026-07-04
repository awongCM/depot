ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

Rails::Controller::Testing.install

module ActiveSupport
  class TestCase
    parallelize(workers: 1)

    fixtures :all

    def login_as(user)
      session[:user_id] = users(user).id
    end

    def logout
      session.delete :user_id
    end

    def setup
      login_as :one if self.is_a?(ActionController::TestCase)
    end
  end
end

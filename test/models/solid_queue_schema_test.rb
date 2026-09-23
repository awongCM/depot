require "test_helper"

class SolidQueueSchemaTest < ActiveSupport::TestCase
  test "solid queue tables exist in the primary schema" do
    connection = ActiveRecord::Base.connection

    %w[
      solid_queue_jobs
      solid_queue_ready_executions
      solid_queue_scheduled_executions
      solid_queue_claimed_executions
      solid_queue_blocked_executions
      solid_queue_failed_executions
      solid_queue_pauses
      solid_queue_processes
      solid_queue_semaphores
    ].each do |table|
      assert connection.data_source_exists?(table), "#{table} should exist after schema load"
    end
  end
end

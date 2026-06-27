require 'test_helper'

class NotifierTest < ActionMailer::TestCase
  test "error_occured" do
    error = ActiveRecord::RecordNotFound.new("cart not found")
    mail = Notifier.error_occured(error)

    assert_equal "Depot App Error Incident", mail.subject
    assert_equal ["dave@example.com"], mail.to
    assert_equal ["depot@example.com"], mail.from
    assert_match "cart not found", mail.body.encoded
  end
end

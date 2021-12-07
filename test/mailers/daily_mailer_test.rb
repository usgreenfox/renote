require 'test_helper'

class DailyMailerTest < ActionMailer::TestCase
  test "remind_notification" do
    mail = DailyMailer.remind_notification
    assert_equal "Remind notification", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end

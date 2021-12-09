namespace :mails do
  desc "remind to user"
  task remind_note: :environment do
    DailyMailer.remind_notification.deliver
  end
end

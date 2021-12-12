namespace :mails do
  desc "remind to user"
  task remind_note: :environment do
    reminds = Remind.all
    reminds.each do |remind|
      base_date = remind.updated_at.to_date
      first = base_date + remind.first_notice.days
      second = base_date + remind.second_notice.days
      third = base_date + remind.third_notice.days


      case Time.now.to_date
      when first, second, third
        DailyMailer.remind_notification(remind).deliver
      end
    end

  end
end

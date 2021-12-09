class DailyMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.daily_mailer.remind_notification.subject
  #
  def remind_notification
    reminds = Remind.all
    reminds.each do |remind|
      base_date = remind.updated_at.to_date
      first = base_date + remind.first_notice.days
      second = base_date + remind.second_notice.days
      third = base_date + remind.third_notice.days


      case Time.now.to_date
      when first, second, third
        @note = remind.note
        mail(to: remind.user.email, subject: "ノートを振り返ろう")
      end
    end
  end
end

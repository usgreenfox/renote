class DailyMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.daily_mailer.remind_notification.subject
  #
  def remind_notification(remind)
    @remind = remind
    mail(to: @remind.user.email, subject: @remind.note.title)
  end
end

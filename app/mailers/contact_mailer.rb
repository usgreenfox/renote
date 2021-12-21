class ContactMailer < ApplicationMailer
  def received_email(contact)
    @contact = contact
    mail(to: ENV['USER_NAME'], subject: 'お問い合わせを承りました')
  end
end

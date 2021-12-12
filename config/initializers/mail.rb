if Rails.env.production?
ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.smtp_settings = {
  port: 587,
  address: 'smtp.gmail.com',
  domain: 'smtp.gmail.com',
  user_name: ENV['USER_NAME'],
  password: ENV['APP_PASSWORD'],
  authentication: 'plain',
  enable_starttls_auto: true,
}
elsif Rails.env.development?
	ActionMailer::Base.delivery_method = :letter_opener_web
else
  ActionMailer::Base.delivery_method = :test
end
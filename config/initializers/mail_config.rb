ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.smtp_settings = {
  address: 'smtp.gmail.com',
  domain: 'gmail.com',
  port: 587,
  user_name: 'chokichoki20200401@gmail.com',
  password: "iqmi dgnj xmyj xmav",
  authentication: 'plain',
  enable_starttls_auto: true
}

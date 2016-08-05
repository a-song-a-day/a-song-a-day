class TransactionalMailer < ApplicationMailer

  def login(user, token)
    @name = user.name
    @token = token
    @preheader = "Here's your magic log in link!"

    headers['X-Mailgun-Campaign-Id'] = 'login'

    mail to: user.email, subject: 'Log in to A Song A Day'
  end

  def welcome(user, token)
    @name = user.name
    @token = token
    @preheader = "Just confirm your email address to start receiving great music."

    headers['X-Mailgun-Campaign-Id'] = 'welcome'

    mail to: user.email, subject: 'Welcome to A Song A Day!'
  end
end

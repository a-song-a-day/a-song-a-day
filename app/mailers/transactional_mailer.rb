class TransactionalMailer < ApplicationMailer

  def login(user, token)
    @name = user.name
    @token = token
    @preheader = "Here's your magic log in link!"

    mail to: user.email, subject: 'Log in to A Song A Day'
  end

  def welcome(user, token)
    @name = user.name
    @token = token
    @preheader = "Just confirm your email address to start receiving great music."

    mail to: user.email, subject: 'Welcome to A Song A Day!'
  end
end

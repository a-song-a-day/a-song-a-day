class TransactionalMailer < ApplicationMailer

  def login(user, token)
    @name = user.name
    @token = token

    mail to: user.email, subject: 'Log in to A Song A Day'
  end

  def welcome(user, token)
    @name = user.name
    @token = token

    mail to: user.email, subject: 'Welcome to A Song A Day!'
  end
end

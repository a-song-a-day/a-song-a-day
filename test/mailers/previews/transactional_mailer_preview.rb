# Preview all emails at http://localhost:3000/rails/mailers/transactional_mailer
class TransactionalMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/transactional_mailer/login
  def login
    user = User.first!
    token = user.access_tokens.create!
    TransactionalMailer.login(user, token)
  end

  # Preview this email at http://localhost:3000/rails/mailers/transactional_mailer/welcome
  def welcome
    user = User.first!
    token = user.access_tokens.create!
    TransactionalMailer.welcome(user, token)
  end

end

# http://a-song-a-day.dev/rails/mailers/transactional_mailer
class TransactionalMailerPreview < ActionMailer::Preview

  # http://a-song-a-day.dev/rails/mailers/transactional_mailer/login
  def login
    user = User.first!
    token = user.access_tokens.create!
    TransactionalMailer.login(user, token)
  end

  # http://a-song-a-day.dev/rails/mailers/transactional_mailer/welcome
  def welcome
    user = User.first!
    token = user.access_tokens.create!
    TransactionalMailer.welcome(user, token)
  end

end

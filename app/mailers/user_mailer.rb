class UserMailer < ActionMailer::Base
  default :from => "brett.bim@gmail.com"

  def send_password(user, random_password)
    @user = user
    @random_password = random_password
    mail(:to => @user.email, :subject => "Your password for The Sports Pool Hub has been reset")
  end
end

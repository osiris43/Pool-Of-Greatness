class UserMailer < ActionMailer::Base
  default :from => "brett.bim@gmail.com"

  def send_password(user)
    @user = user
    mail(:to => @user.email, :subject => "Your requested password for The Sports Pool Hub")
  end
end

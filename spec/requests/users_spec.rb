require 'spec_helper'

describe "Users" do
  describe 'signup' do
    describe 'failure' do
      it "does not make a new user" do
        lambda do
          visit signup_path
          click_button
          response.should render_template("users/new")
          response.should have_selector("div.error_messages")
        end.should_not change(User, :count)
      end
    end

    describe "success" do
      it "creates a user" do
        lambda do
          visit signup_path
          fill_in "user_name",                   :with => "user name"
          fill_in "user_username",               :with => "username"
          fill_in "user_email",                  :with => "test@test.com"
          fill_in "user_password",               :with => "abcdefgh"
          fill_in "user_password_confirmation",  :with => "abcdefgh"
          click_button "Sign up"
        end.should change(User, :count).by(1)
      end
    end
  end
end

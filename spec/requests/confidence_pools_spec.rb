=begin
require 'spec_helper'

describe "ConfidencePools" do
  describe "links work" do
    describe "with a real user" do

      let(:user) {FactoryGirl.create(:user)}
      before do
        visit login_path
        fill_in "Username or Email Address", with: "testuser1"
        fill_in "password", with: "password"
        click_button "Log in"

      end

      it {should have_link('LOG OUT', href: logout_path)}

      let(:bowl_season) {FactoryGirl.create(:bowl_season)}
      let(:confidence_pool) {FactoryGirl.create(:confidence_pool)}
      let(:config){FactoryGirl.create(:pool_config, pool: confidence_pool, :config_key => "ConfidencePoolDeadline", :config_value => "2012-01-01")}
      it "should have some bowls" do
        bowl_season
        config
        #visit viewbowls_confidence_pool_path(confidence_pool)
        response.status.should be(200)
      end
    end
  end
end
=end

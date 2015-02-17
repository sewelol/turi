require 'rails_helper'

RSpec.describe Account, type: :model do
  describe "passwords" do
    it "needs a password and confirmation to save" do
      u = Account.new(username: "runar")

      u.save
      expect(u).to_not be_valid

      u.password = "password"
      u.password_confirmation = ""
      u.save
      expect(u).to_not be_valid

      u.password_confirmation = "password"
      u.save
      expect(u).to_not be_valid

      u.email = "email@xxx.com"
      u.save
      expect(u).to be_valid
    end

    it "needs password and confirmation to match" do
      u = Account.create(
        username: "runar",
        email: "runar@runar.runar",
        password: "damndamn",
        password_confirmation: "damn")

      expect(u).to_not be_valid
    end
  end

  describe "authentication" do
    # let is used to define a memorized helper method. The value will be cached across multiple calls in the same example but not across examples.
    # why use let? http://stackoverflow.com/questions/5359558/when-to-use-rspec-let
    let(:user) { Account.create(
      username: "runar",
      email: "runar@runar.com",
      password: "123456",
      password: "123456") }

    it "authenticates with a correct password" do
      expect(user.authenticate("123456")).to be
    end

    it "does not authenticate with an incorrect password" do
      expect(user.authenticate("654321")).to_not be
    end
  end
end

require 'rails_helper'

=begin
Use let to define a memorized helper method. The value will be cached
across multiple calls in the same example but not across examples.

Note that let is lazy-evaluated: it is not evaluated until the first time
the method it defines is invoked. You can use let! to force the method's
invocation before each example.
=end

RSpec.describe UsersController, type: :controller do
  let(:user) { FactoryGirl.create(:user) }

  context "get 'show'" do
    it "returns http success" do
      sign_in_as!(user)
      get :show, id: user.id

      expect(response).to render_template(:show)
    end

    it "assigns my user id" do

    end
  end

end

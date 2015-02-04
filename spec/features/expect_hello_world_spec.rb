require 'rails_helper'

RSpec.feature "Hello World" do

  scenario "Check Hello World" do

    visit '/'
    expect(page).to have_content("Hello World")

  end

end
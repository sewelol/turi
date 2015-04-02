require 'rails_helper'

RSpec.feature "Equipment List" do
    before do
        @user = FactoryGirl.create(:user)
        @trip = FactoryGirl.create(:trip, :user_id => @user.id)
        FactoryGirl.create(:participant, :trip_id => @trip.id, :user_id => @user.id, :participant_role_id => ParticipantRole.owner.id)
        @equipment_list = FactoryGirl.build(:equipment_list, :trip_id => @trip.id)
        login_as(@user, :scope => :user)
    end

    scenario "Create a new list" do
        visit trip_equipment_lists_path(@trip)
        
        click_link 'new_list' # why does this not work? something with rendering sidebar?
        expect(page.current_page).to eq(new_trip_equipment_list_path(@trip))
        fill_in :name, :with => @equipment_list.name
        fill_in :description, :with => @equipment_list.description
        fill_in :icon, :with => @equipment_list.icon
        click_button 'submit'

        expect(page).to have_content(I18n.t 'trip_equipment_list_created')
        expect(page).to have_content(@equipment_list.name)
    end

    scenario "Edit a list" do
    end

end

require 'rails_helper'

RSpec.feature "Equipment List" do
    before do
        @user = FactoryGirl.create(:user)
        @trip = FactoryGirl.create(:trip, :user_id => @user.id)
        FactoryGirl.create(:participant, :trip => @trip, :user => @user, :participant_role_id => ParticipantRole.owner.id)
        @equipment_list = FactoryGirl.build(:equipment_list, :trip => @trip, :user => @user)
        login_as(@user, :scope => :user)
    end

    scenario "Create a new list" do
        # can't click on trip_sidebar so move directly into the new path
        visit new_trip_equipment_list_path(@trip)
        
        fill_in :equipment_list_name, :with => @equipment_list.name
        fill_in :equipment_list_description, :with => @equipment_list.description
        fill_in :equipment_list_icon, :with => @equipment_list.icon
        click_button 'submit'

        expect(page).to have_content(I18n.t 'trip_equipment_list_created')
        expect(page).to have_content(@equipment_list.name)
        expect(page).to have_content(@equipment_list.description)
    end

    scenario "Edit a list" do
        @equipment_list = FactoryGirl.create(:equipment_list, :trip => @trip, :user => @user)
        visit trip_equipment_list_path(@trip, @equipment_list)

        click_link 'edit_equipment_list'
        expect(page.current_path).to eq(edit_trip_equipment_list_path(@trip, @equipment_list))
        fill_in :equipment_list_name, :with => "Something"
        click_button 'submit'

        expect(page.current_path).to eq(trip_equipment_list_path(@trip, @equipment_list))
        expect(page).to have_content(I18n.t 'trip_equipment_list_updated')
        expect(page).to have_content("Something")
        expect(page).to_not have_content(@equipment_list.name)
    end

    scenario "Delete a list" do
        @equipment_list = FactoryGirl.create(:equipment_list, :trip => @trip, :user => @user)
        visit trip_equipment_list_path(@trip, @equipment_list)

        click_link 'delete_equipment_list'

        expect(page).to have_content(I18n.t('trip_equipment_list_deleted'))
    end

end

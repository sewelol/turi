require 'rails_helper'

RSpec.feature "Equipment List" do
    before do
        user = FactoryGirl.create(:user)
        @trip = FactoryGirl.create(:trip, :user_id => user.id)
        @participant_owner = FactoryGirl.create(:participant, trip_id: @trip.id, user_id: user.id, participant_role_id: ParticipantRole.owner.id)
        @equipment = FactoryGirl.build(:equipment_list, :trip_id => @trip.id)
        sign_in_as!(user)
    end



    scenario "Create a Equipment List" do
        visit trip_path(@trip)

        click_link 'new_equipment_list'
        expect(page.current_path).to eq(new_trip_equipment_list_path(@trip))
        
        fill_in 'equipment_list_name', :with => @equipment.name
        fill_in 'equipment_list_description', :with => @equipment.description
        fill_in 'equipment_list_icon', :with => @equipment.icon

        click_button 'submit'

        # Dirty!
        expect(page.current_path).to eq(trip_equipment_list_path(@trip, 1))
        expect(page).to have_content(I18n.t 'trip_equipment_list_created')
        expect(page).to have_content(@equipment.name)

        # check if the list is in the navbar in the trip view
        visit trip_path(@trip)
        click_link @equipment.name + '_equipment_link'
        # also very dirty!
        expect(page.current_path).to eq(trip_equipment_list_path(@trip, 1))
    end

    scenario "Edit the Equipment list as the creator" do
        equipmentlist = FactoryGirl.create(:equipment_list, :trip_id => @trip.id)
        visit trip_path(@trip)
        click_link @equipment.name + '_equipment_link'

        expect(page).to have_content(@equipment.name)
        click_link "edit_equipment_link"

        expect(page.current_path).to eq(edit_trip_equipment_list_path(@trip, equipmentlist))

        fill_in 'equipment_list_name', :with => "Edited equipment list name"
        click_button 'submit'

        expect(page.current_path).to eq(trip_equipment_list_path(@trip, equipmentlist))
        expect(page).to have_content(I18n.t 'trip_equipment_list_updated')
        expect(page).to have_content("Edited equipment list name")
        expect(page).not_to have_content(@equipment.name)
    end

    scenario "Edit the Equipment list as a 'stranger'" do
    end

    scenario "Delete the Equipment List as the creator" do
        equipmentlist = FactoryGirl.create(:equipment_list, :trip_id => @trip.id)
        visit trip_path(@trip)
        click_link @equipment.name + '_equipment_link'

        expect(page.current_path).to eq(trip_equipment_list_path(@trip, equipmentlist))        
        expect(page).to have_content(@equipment.name)

        click_link 'delete_equipment_list'
        expect(page.current_path).to eq(trip_path(@trip))
        expect(page).not_to have_content(@equipment.name)
        expect(page).to have_content(I18n.t 'trip_equipment_list_deleted')
                                       
    end

    scenario "Delete the Equipment as a 'stranger'" do
    end

end




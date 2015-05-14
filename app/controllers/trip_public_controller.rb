class TripPublicController < ApplicationController
    include EquipmentConcern
    before_action {|c| c.set_trip params[:id]}
    before_action {|c| c.equipment_lists_users_summary @trip.equipment_lists}



    def show
       unless @trip.public || TripPolicy.new(current_user, @trip).show?
           flash[:alert] = t('trip_not_public')
           redirect_to dashboard_path
           return 
       end


       # move down when articles get public variable FIXME
       @articles = Kaminari.paginate_array(@trip.articles.where(:public => true)).page(params[:page]).per(1)


       @participants = Kaminari.paginate_array(@trip.participants).page(params[:user]).per(2)


       # For the routes when they get done
       #@routes = [] 
       #@trip.routes.each do |f| 
            # if f.public
            #@routes.push(f)
            # end 
       #end 

        render :show
    end
end

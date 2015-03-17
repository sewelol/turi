require 'dropbox_sdk'
require 'securerandom'

class MediaDropboxController < ApplicationController

  before_action :authenticate_user!

  def auth_start
    trip = Trip.find(params[:trip_id])

    authorize trip, :show?

    authorize_url = get_web_auth.start()

    session[:dropbox_workflow_started] = true
    session[:dropbox_trip_id] = params[:trip_id].to_i

    # Send the user to the Dropbox website so they can authorize our app.  After the user
    # authorizes our app, Dropbox will redirect them here with a 'code' parameter.
    redirect_to authorize_url
  end

  def auth_finish
    begin
      access_token, user_id, url_state = get_web_auth.finish(params)

      trip = Trip.find(session[:dropbox_trip_id])

      authorize trip, :show?

      ApiAccessToken.create(
          token: access_token,
          user_id: current_user.id,
          trip_id: session[:dropbox_trip_id],
          api_provider_id: ApiProvider.dropbox.id
      )

      flash[:info] = I18n.t 'trip_media_account_added'
    rescue DropboxOAuth2Flow::BadRequestError => e
      flash[:error] = I18n.t 'dropbox_auth_bad_request_error', :message => e
    rescue DropboxOAuth2Flow::BadStateError => e
      flash[:error] = I18n.t 'dropbox_auth_bad_state_error', :message => e
    rescue DropboxOAuth2Flow::CsrfError
      flash[:error] = I18n.t 'dropbox_auth_csrf_error'
    rescue DropboxOAuth2Flow::NotApprovedError
      flash[:error] = I18n.t 'dropbox_auth_not_approved_error'
    rescue DropboxOAuth2Flow::ProviderError
      flash[:error] = I18n.t 'dropbox_auth_provider_error'
    rescue DropboxError
      flash[:error] = I18n.t 'dropbox_error'
    ensure
      session[:dropbox_workflow_started] = false
      session[:dropbox_trip_id] = nil
      redirect_to trip_media_path(trip)
    end
  end

  private
  
  def get_web_auth
    redirect_uri = url_for(:action => 'auth_finish')
    DropboxOAuth2Flow.new(ENV['TURI_DROPBOX_KEY'], ENV['TURI_DROPBOX_SECRET'], redirect_uri, session, :dropbox_auth_csrf_token)
  end

end

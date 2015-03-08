require 'dropbox_sdk'
require 'securerandom'

# The media controller parses the connected apis for images.
#
# For new api connections, keep the hash pattern for the view!
#
#   media_x_user = {
#    :access_token => access_token,
#    :folders => [{
#      :path => 'item/path',
#      :name => 'Item Name',
#      :files => []
#    }]
#   }
#
# TODO: Should we sort the images recursive by date instead of using the folder names?
#
class MediaController < ApplicationController

  layout 'trip'

  before_action :authenticate_user!
  after_action :verify_authorized

  def index
    @trip = Trip.find(params[:trip_id])

    # Let only participants of the trip see the media page.
    authorize @trip, :show?

    @access_tokens = @trip.api_access_tokens
  end

  def show
    @trip = Trip.find(params[:trip_id])

    # Let only participants of the trip see the media detail page.
    authorize @trip, :show?

    @access_token = ApiAccessToken.find(params[:id])
    @access_tokens = @trip.api_access_tokens

    if @access_token.api_provider.dropbox?

      encoded_trip_name = @trip.title.downcase.tr(' ', '_')

      @media_user = initialize_dropbox(@access_token, "turi/#{encoded_trip_name}")

    end

    # if access_token.api_provider.google_drive? ...
  end

  def destroy
    trip = Trip.find(params[:trip_id])
    access_token = ApiAccessToken.find(params[:id])

    authorize access_token

    access_token.destroy

    flash[:info] = I18n.t 'trip_media_account_removed'

    redirect_to trip_media_path(trip)
  end

  private

  #
  # Retrieves the user files from dropbox.
  #
  def initialize_dropbox(access_token, root_folder)
    dropbox_user = {
        :access_token => access_token,
        :folders => [{
          # Add a folder manually where we can add all images under the root folder
          :path => root_folder,
          :files => []
        }]
    }

    @dropbox_client = DropboxClient.new(access_token.token)

    begin

      folder_entry = @dropbox_client.metadata(root_folder)

      if folder_entry['is_deleted']
        # If the folder already existed but was deleted, dropbox will not throw an error,
        # so we have to do this by our self. This error will be handled below.
        raise DropboxError.new("Path '#{root_folder}' not found")
      end

      folder_entry['contents'].each do |folder_file|

        if folder_file['is_dir']
          dropbox_parse_folder(folder_file, dropbox_user)
        else
          # Root path images
          media_file = @dropbox_client.media(folder_file['path'])
          dropbox_user[:folders][0][:files].push({
            :path => media_file['url']
          })
        end

      end

    rescue DropboxAuthError
      # The user revoked the rights for turi or the token expired.
      access_token.destroy
      flash[:error] = I18n.t 'dropbox_revoked_access'
      redirect_to trip_media_path(@trip)
    rescue DropboxError
      flash[:warn] = I18n.t('dropbox_folder_not_found_html', :name => root_folder)
      redirect_to trip_media_path(@trip)
    end

    return dropbox_user
  end

  #
  # Parses the dropbox folder for files.
  #
  #
  def dropbox_parse_folder(folder, dropbox_user)

    files = []

    # Read the folder
    folder_files = @dropbox_client.metadata(folder['path'])

    # Go through the folder files
    folder_files['contents'].each do |folder_file|

      if folder_file['is_dir']
        dropbox_parse_folder(folder_file, dropbox_user)
      else
        media_file = @dropbox_client.media(folder_file['path'])
        files.push({
          :path => media_file['url']
        })
      end

    end

    dropbox_user[:folders].push({
      :path => folder['path'],
      :files => files
    })

  end

end
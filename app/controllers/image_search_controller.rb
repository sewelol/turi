class ImageSearchController < ApplicationController

  def index

    response = RestClient.get 'https://unsplash.it/list'

    fetched_images = JSON.parse(response.body)

    images = []

    fetched_images.each do |fetched_image|
      images.push id: fetched_image['id'], url: "https://unsplash.it/1060/260?image=#{fetched_image['id']}", thumb_url: "https://unsplash.it/200/150?image=#{fetched_image['id']}"
    end

    render json: images.sample(8)

  end

end

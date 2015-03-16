class ArticlesController < ApplicationController
  before_action :authenticate_user!

  def index
    @trip = Trip.find(params[:id])
    @articles = @trip.articles.find(params[:id])
  end

  def show
    @article = Article.find(params[:id])
  end

  def new

  end

  def create

  end

end

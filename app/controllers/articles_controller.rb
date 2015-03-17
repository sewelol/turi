class ArticlesController < ApplicationController
  layout 'trip'

  before_action :set_trip

  def index
    @articles = @trip.articles
  end

  def show
    @article = Article.find(params[:id])
  end

  def new
    @article = @trip.articles.build
  end

  def create
    @article = @trip.articles.build(article_params)
    if @article.save
      flash[:notice] = 'Blog entry created.'
      redirect_to [@trip, @article]
    else
      flash[:alert] = 'Blog creation error.'
      render 'new'
    end
  end

  def edit
    @article = @trip.articles.find(params[:id])
  end

  def update
    @article = @trip.articles.find(params[:id])

    if @article.update(article_params)
      flash[:notice] = 'Blog entry updated.'
    else
      flash[:notice] = 'Update aborted.'
    end

    redirect_to [@trip, @article]
  end

  def destroy
    @article = @trip.articles.find(params[:id])
    @article.destroy
    redirect_to trip_articles_path(@trip)
  end

  private

  def set_trip
    @trip = Trip.find(params[:trip_id])
  end

  def article_params
    params.require(:article).permit(:title, :content)
  end
end

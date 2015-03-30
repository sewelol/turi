class Web::PageController < ApplicationController

  layout 'webpage'

  def index
    render 'web/index'
  end

  def features
    render 'web/features'
  end

  def faq
    render 'web/faq'
  end

end

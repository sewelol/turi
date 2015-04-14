require 'rails_helper'

RSpec.describe Article, type: :model do
  describe 'create an article' do
    it 'is invalid without a title' do
      article = Article.create(title: nil)
      expect(article).to_not be_valid
      expect(article.errors.messages[:title]).to include "can't be blank"
    end

    it 'is invalid with no content' do
      article = Article.create(title: nil)
      expect(article).to_not be_valid
      expect(article.errors.messages[:title]).to include "can't be blank"
    end
  end
end

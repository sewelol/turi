class Trip < ActiveRecord::Base
  acts_as_taggable # Alias for acts_as_taggable_on :tags
  ActsAsTaggableOn.remove_unused_tags = true

  belongs_to :user
  has_many :participants
end

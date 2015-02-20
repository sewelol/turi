class Trip < ActiveRecord::Base
  acts_as_taggable # Alias for acts_as_taggable_on :tags
  ActsAsTaggableOn.remove_unused_tags = true

  belongs_to :account

  def self.search(title_search, location_search, tag_search)
    @trips = nil

    if title_search.present? || location_search.present?
      get_fields = Trip.where('title LIKE ? AND start_loc LIKE ? AND end_loc LIKE ?', "%#{title_search}%", "%#{location_search}%", "%#{location_search}%")
    end

    if tag_search.present?
      get_tagged = Trip.tagged_with(tag_search, :on => :tags)
      if get_fields.blank?
        @trips = get_tagged
      else
        @trips = get_tagged & get_fields
      end
    else
      @trips = get_fields
    end

  end

end

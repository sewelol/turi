class Trip < ActiveRecord::Base
  acts_as_taggable # Alias for acts_as_taggable_on :tags
  ActsAsTaggableOn.remove_unused_tags = true

  belongs_to :user

  def self.search(title_search, location_search, tag_search, date_beg, date_end)
    @trips = nil

    if title_search.present? || location_search.present?
      @trips = Trip.where('title LIKE ? AND (start_loc LIKE ? OR end_loc LIKE ?)', "%#{title_search}%","%#{location_search}%", "%#{location_search}%")
    end

    if tag_search.present?
      ary_tag = tag_search.split
      #get_tagged = Trip.tagged_with(ary_tag, :on => :tags)
      if @trips.nil?
        @trips = Trip.tagged_with(ary_tag, :on => :tags)
      else
        @trips = @trips.tagged_with(ary_tag, :on => :tags)
      end
    end

    if date_beg.present? || date_end.present?
      #date_beg = date_end unless date_beg.present?
      #date_end = date_beg unless date_end.present?

      if @trips.nil?
        @trips = Trip.where('start_date >= ? AND end_date <= ?', date_beg, date_end)
      else
        @trips = @trips.where('start_date >= ? AND end_date <= ?', date_beg, date_end)
      end

    end

    return @trips
  end

end

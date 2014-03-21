
class Movie < ActiveRecord::Base
  # Returns an array containing allowed  values for ratings
  def self.all_ratings ; %w[G PG PG-13 R NC-17] ; end

  # Validate model fields
  def title=(s)
    write_attribute(:title, s.to_s.titleize) # The to_s is in case you get nil/non-string
  end
   validate :release_date_cannot_be_in_the_past

  def release_date_cannot_be_in_the_past
    errors.add(:release_date, "can't be in the past") if
      !release_date.blank? and release_date < Date.today
  end
  auto_strip_attributes :title
  validates_uniqueness_of :title
  validates_length_of :title, :minimum => 3, :allow_blank => true
  validates :title, :presence => true
  validates :release_date, :presence => true
  validate :released_1930_or_later # uses custom validator below
  validates :rating, :inclusion => {:in => Movie.all_ratings},
    :unless => :grandfathered?

  # Check that release date is greater than Jan 1, 1930.
  # Set error if otherwise.
  def released_1930_or_later
    errors.add(:release_date, 'must be 1930 or later') if
      release_date && release_date < Date.parse('1 Jan 1930')
  end

  # The rating system did not go into effect until Nov 1, 1968.
  # Therefore, ignore ratings validation for movies released
  # prior to this.
  @@grandfathered_date = Date.parse('1 Nov 1968')
  def grandfathered?
    release_date && release_date >= @@grandfathered_date
  end
end

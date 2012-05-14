class OldReview < ActiveRecord::Base
  belongs_to :offering, :foreign_key => :old_id, :primary_key => :old_id

  @averageable_columns = %w(
      coverall cpace cwork cinterest ctas cmatchorc cdiversity
      hlearn hhard hinterest
      efair ehard
      loverall lhard ledvalue ltas
      reffort rattend
  )
  @tally_columns = {:roffice => 'Yes', :rneed => 'Yes'}

  def self.average_reviews(reviews)
    avgs, counts = Review.average_records(reviews, @averageable_columns)
    avgs['coverall'] *= (5.0/24.0) if avgs['coverall']
    return avgs, counts # FIXME why does it complain if I don't write 'return'?
  end

  # [:grade, :course_rating, :prof_rating, :workload_rating]
  def self.average_reviews_for_new_schema(reviews)
    avgs, counts = Review.average_records(reviews, %w(coverall hard))
    (avgs['coverall'] *= (5.0/24.0)) if avgs['coverall']
    a = {
      :course_rating => avgs['coverall'],
      :workload_rating => avgs['hhard'],
      # TODO prof_ratings & grade
    }
    c = {
      :course_rating => counts['coverall'],
      :workload_rating => counts['hhard'],
    }
    return a, c
  end
end

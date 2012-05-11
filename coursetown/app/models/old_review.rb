class OldReview < ActiveRecord::Base
  belongs_to :offering, :foreign_key => :old_id, :primary_key => :old_id

  @averageable_columns = %w(
      coverall cpace cwork cinterest ctas cmatchorc cdiversity
      hlearn hhard hinterest
      efair ehard
      loverall lhard ledvalue ltas
      reffort rattend
  )
  @tally_columns = {
    :roffice => 'Yes', :rneed => 'Yes'
  }

  # params: :prof_ids => [1,2,3], :course_id => 1
  # returns:
  #   nil on failure
  #   avgs, counts, reviews on success. both are column_name => value hashes
  def self.roll_up(course_ids, prof_ids)
    return nil unless prof_ids && course_ids # TODO invalid argument exception

    prof_set, course_set = Set.new(prof_ids), Set.new(course_ids)
    offerings = Offering.includes(:courses, :professors, :old_reviews).
      where('courses.id IN (?) AND professors.id IN (?)', course_ids, prof_ids).
      select do |o| # check that ALL profs match
        # FIXME technically this will break if a prof appears twice for the same
        # offering which we don't enforce
        o.professors.size == prof_ids.size &&
          o.courses.size >= course_ids.size &&
          o.professors.all? { |p| prof_set.include? p.id } &&
          o.courses.all? { |c| course_set.include? c.id }
      end
    reviews = offerings.map(&:old_reviews).flatten

    # tallies = Hash[@tally_columns.map {|c| [c, 0]}]
    # offerings.each {|o| }
    avgs, counts = Review.average_records(reviews, @averageable_columns)

    # convert certain ratings to star scale
    %w(coverall loverall).each do |key|
      avgs[key] *= 5.0/24.0
    end

    return avgs, counts, reviews
  end
end

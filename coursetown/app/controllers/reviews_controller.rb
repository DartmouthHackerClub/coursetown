class ReviewsController < ApplicationController
  def show
    @review = Review.find_by_id(params[:id], 
      :include => {:offering => [:professors, :courses]})
    if @review.nil?
      render :status => 404
      return
    end
  end

  def course
    @course = Course.find_by_id(params[:id])
    @reviews = @course.reviews
  end

  def prof
    @prof = Professor.find_by_id(params[:id])
    @reviews = @prof.reviews
  end

  # TODO test
  def course_prof
    @prof = Professor.find_by_id(params[:prof_id])
    @course = Course.find_by_id(params[:course_id])
    @reviews = @prof.reviews.where(:course => @course)
  end

  # form for creating new review
  def new
    # TODO populate with this user's grades (if pre-fetch = true?)
    # TODO check if the user has taken this class already during a different offering,
    #   and suggest they review the other time slot (but don't force it, because users can take some classes multiple times)

    # TODO direct them to a login page (or, better yet, a lightbox/pop-over)
    if (current_user = logged_in_user).nil?
      render :status => 401
      return
    end

    @review = Review.new

    # TODO make this check mandatory!
    @review.offering = Offering.find_by_id(params[:offering_id]) if params.has_key? :offering_id

    if @review.offering.nil?
      render :status => 404
      return
      # TODO redirect user to a course selection page (maybe)
    end
  end

  # TODO route & view
  # pulls grades from transcript, then prepopulates field with them
  def new_batch
    # TODO
  end

  # TODO TEST
  # TODO course will already be on the user's schedule
  # receives data from 'new' and creates review
  def create
    @review = Review.new(params[:review])
    current_user = logged_in_user
    if current_user.nil? # unauthorized
      render :status => 401
      return
    end
    @review.user = current_user

    @review.save!

    # TODO there's probably a more elegant convention for this
    # add course to user's schedule (if it's not there yet)
    if !(current_user.schedule_offerings.include? @review.offering)
      sched = Schedule.new(:offering => @review.offering, :user => current_user)
      sched.save!
      current_user.schedules << sched # TODO no need to save?
    end
 end

 def update
  # TODO
end

def destroy
  review = Review.find_by_id(params[:id])

  if review.user != logged_in_user
    render :status => 401 # unauthorized
    return
  end

  review.destroy
end

end

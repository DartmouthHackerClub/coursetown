class ReviewsController < ApplicationController
  def show
    @review = Review.find_by_id params[:id], 
      :include => [:course, {:offering => :professors}]
    # TODO if nil, show error page & maybe search for other things
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
    
    @review.author = current_user
    @review.save

    # TODO there's probably a more elegant convention for this
    # add course to user's schedule (if it's not there yet)
    if current_user.schedule_offerings.include? @review.offering
      current_user.schedule_offerings << @review.offering
      current_user.save # TODO what do I need to save to ensure that relationship is established?
    end
 end

 def update
  # TODO
end

def destroy
  review = Review.find_by_id(params[:id])

  if review.author == logged_in_user
    review.destroy
  else # unauthorized
    render :status => 401
    return
  end
end

end

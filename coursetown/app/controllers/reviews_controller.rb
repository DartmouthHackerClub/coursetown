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
    @course = Course.find_by_id(params[:id]).includes(:reviews)
    @reviews = @course.reviews
    @avgs = avg_reviews(@reviews)
    # TODO avg by prof too (& display who teaches it best)
  end

  def prof
    @prof = Professor.find_by_id(params[:id]).includes(:reviews)
    @reviews = @prof.reviews
    @avgs = avg_reviews(@reviews)
    # TODO avg by course too (& compare this prof in each course to others)
  end

  # aggregates reviews of offerings that share both a prof and a course
  #   w/ this offering
  # TODO: test
  def offering
    @offering = Offering.find_by_id(params[:offering_id])
    @profs = @offering.professors.includes(:offerings)
    @courses = @offering.courses.includes(:offerings => :reviews)
    # TODO is this completely unnecessary?
    @reviews = @avgs = nil

    prof_string = @profs.map(&:name).sort.join(', ')

    # TODO WIP
    @avgs_by_profs = {}
    @courses.offerings.group_by {|o| 
      o.professors.map(&:name).sort.join(', ')
    }.each{|k,v|
      if k == prof_string
        @reviews = v
        @avgs = avg_reviews(@reviews)
      else
        @avgs_by_profs[k] = avg_reviews(v.map(&:reviews).flatten)
      end
    }

    # TODO do the same thing by individual profs & tuck these results
    #   in an optional block OR use them if no reviews exist w/ this group

    # TODO find best profs teaching this course & see if 
    #   (A) it conflicts w/ user's schedule
    #   (B) this is it

  end

  # form for creating new review
  def new
    # TODO populate with this user's grades (if pre-fetch = true?)
    # TODO check if the user has taken this class already during a different offering,
    #   and suggest they review the other time slot (but don't force it, because 
    #   users can take some classes multiple times)

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

  # receives data from 'new' and creates review
  def create
    current_user = logged_in_user
    if current_user.nil? # unauthorized
      render :status => 401
      return
    end

    @review = Review.new(params[:review])
    @review.user = current_user
    # TODO wrap everything after this point in one DB transaction?
    @review.save!

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

  # helper functions

  # note: dimensions have to be _attributes_ of the review object
  #   so :user doesn't work, but :user_id does.
  def avg_reviews(reviews, dimensions=nil)
    dimensions = dimensions || [:course_rating, :prof_rating, :workload, :grade]
    sum = {}
    dimensions.each { |dim| sum[dim] = 0 }
    reviews.each { |review| dimensions.each { |dim| sum[dim] += review[dim] } }
    num_reviews = reviews.size
    sum.each_key{ |key| sum[key] /= num_reviews }
  end
end

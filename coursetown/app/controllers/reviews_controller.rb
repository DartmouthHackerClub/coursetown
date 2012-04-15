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
    @course = Course.find( params[:id], :include => :reviews )
    @reviews = @course.reviews
    @avgs, counts = avg_reviews(@reviews)
    # TODO avg by prof too (& display who teaches it best)
  end


  def prof
    @prof = Professor.find( params[:id], :include => :reviews )
    @reviews = @prof.reviews
    @avgs, counts = avg_reviews(@reviews)
    # TODO avg by course too (& compare this prof in each course to others)
  end


  def offering
    @offering = Offering.find(params[:id],
      :include => [:professors, {:courses => {:offerings => [:reviews, :professors]}}])
    if @offering.nil? || @offering.professors.empty? || @offering.courses.empty?
      render :status => 404
      return
    end

    # description = specific description OR first existing course description
    if @offering.specific_desc
      @description = @offering.specific_desc
    elsif !(descs = @offering.courses.select(&:desc)).empty?
      puts "DESCS: #{descs}"
      @description = descs.first.desc
    else
      @description = nil
    end

    # if user has taken this course, get which offering(s) they took
    @schedule_offerings = nil
    if @current_user
      @schedule_offerings = Schedule.find_all_by_user_id_and_course_id(
        @current_user.id, @offering.courses.map(&:id),
        :include => :offering).map(&:offering)
      @in_wishlist = !Wishlist.find_by_user_id_and_course_id(
        @current_user.id, @offering.courses.map(&:id)).nil?
    end

    _year, _term = current_year_and_term
    puts "YEAR/TERM: #{_year} #{_term}"

    # get all offerings
    terms = Hash[%w{W S X F}.each_with_index.to_a]
    @prof_str = @offering.professors.map(&:name).sort.join(', ')
    all_offerings = @offering.other_offerings(:include => :reviews)
    # TODO filter out to just current & future offerings
    @other_offerings = all_offerings.select { |x| x != @offering }
    in_past = Proc.new do |o|
      o.year < _year || ((o.year == _year) && (terms[o.term] < terms[_term]))
    end
    @future_offerings = all_offerings.select { |o| !in_past.call(o) }
    @past_offerings = all_offerings.select { |o| in_past.call(o) }

    all_reviews = all_offerings.map(&:reviews).flatten.uniq
    # all_reviews = @offering.courses.map(&:reviews).flatten.uniq
    @reviews_by_profs = all_reviews.group_by do |review|
      review.professors.map(&:name).sort.join(", ")
    end

    # get comments, randomize their order
    # TODO display a smarter selection of comments
    # TODO display comments about class w/ other prof, prof w/ other class
    @prof_comments = all_reviews.select { |x|
      x.prof_comment && !x.prof_comment.empty?
    }.shuffle!
    @course_comments = all_reviews.select { |x|
      x.course_comment && !x.course_comment.empty?
    }.shuffle!
    @workload_comments = all_reviews.select { |x|
      x.workload_comment && !x.workload_comment.empty?
    }.shuffle!

    # avg by prof
    @avgs_by_profs = {}
    @reviews_by_profs.each do |key, reviews|
      # TODO currently throwing away the counts...
      # show them on rollover?
      @avgs_by_profs[key], counts = avg_reviews(reviews)
    end

    # now review_buckets only contains reviews w/ other profs
    @reviews = @reviews_by_profs.delete( @prof_str )
    @avgs = @avgs_by_profs.delete( @prof_str )

    # get the overal average of this course
    # TODO should be a rollup for this to make it searchable!
    @course_avgs, counts = avg_reviews(all_reviews)

    # TODO find best profs teaching this course & see if
    #   (A) it conflicts w/ user's schedule
    #   (B) this is it
  end


  # form for creating new review
  def new
    # TODO populate with this user's grades (if pre-fetch = true?)
    # TODO check if the user has taken this class already during a different
    #   offering, and suggest they review the other time slot (but don't force
    #   it, because users can take some classes multiple times)

    # TODO direct them to a login page (or, better yet, a lightbox/pop-over)
    force_login && return if @current_user.nil?

    @review = Review.new

    # TODO make this check mandatory!
    @review.offering = Offering.find(params[:id]) if params.has_key? :id

    if @review.nil? || @review.offering.nil?
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
    if @current_user.nil? # unauthorized
      render :status => 401
      return
    end

    @review = Review.new(params[:review])
    @review.user = @current_user
    # TODO wrap everything after this point in one DB transaction?
    @review.save!

    # add course to user's schedule (if it's not there yet)
    if !(@current_user.schedule_offerings.include? @review.offering)
      sched = Schedule.new(:offering => @review.offering, :user => current_user)
      sched.save!
      @current_user.schedules << sched # TODO no need to save?
    end
  end


  def update
    # TODO
  end


  def destroy
    review = Review.find_by_id(params[:id])

    if review.user != @current_user
      render :status => 401 # unauthorized
      return
    end
    review.destroy
  end

  # helper functions

  # note: dimensions have to be _attributes_ of the review object
  #   so :user doesn't work, but :user_id does.
  def avg_reviews(reviews, dimensions = [:course_rating, :prof_rating, :workload, :grade])
    sum, count = {}, {}
    dimensions.each { |dim| sum[dim] = count[dim] = 0 }
    reviews.each do |review|
      dimensions.each do |dim|
        if review[dim]
          sum[dim] += review[dim]
          count[dim] += 1
        end
      end
    end
    # turn sum into avg
    sum.each_key { |key| count[key] != 0 ? sum[key] /= count[key] : 0 }
    return sum, count
  end
end

# the Knuth shuffle
# citation: http://snippets.dzone.com/posts/show/2994
class Array
  def shuffle!
    size.downto(1) {|i| push(delete(rand(i)))}
    self
  end
end

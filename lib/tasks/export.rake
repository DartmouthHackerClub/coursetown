namespace :export do
  task :reviews => :environment do
    filename = 'scrapers/reviews.csv'
    # OUTPUT:
    # user id, course id, course-prof id, course rating, workload rating
    # user course-prof id if dense enough data, just course id if not
    # OR use mostly course id, but pre-process the data by averaging to reduce course-prof bias

    cs = Course.includes(:offerings => [:professors, :old_reviews, {:schedules => :review}])

    # init these to zero, but they'll actually start at 1
    course_prof_count = 0
    course_count = 0
    user_count = 0

    user_map = {} # old courseguide users
    new_user_map = {} # new coursepicker users
    course_map = {}
    course_prof_map = {}

    out = []

    old_user_ids = cs.map(&:offerings).flatten.uniq.map(&:old_reviews).flatten.map(&:reviewer)
    new_user_count = old_user_ids.size

    cs.each do |course|

      if (course_id = course_map[course.id]).blank?
        course_id = (course_count += 1)
        course_map[course.id] = course_id
      end

      # group offerings by profs and get aggregate avg
      gps = course.offerings.group_by(&:prof_string)

      # output each rating
      gps.each do |gp, offerings|

        # get course_prof_id
        course_prof_string = "#{course.id}|#{offerings.first.prof_string}"
        if (course_prof_id = course_prof_map[course_prof_string]).blank?
          course_prof_id = (course_prof_count += 1)
          course_prof_map[course_prof_string] = course_prof_id
        end

        # old reviews
        offerings.map(&:old_reviews).flatten.each do |review|
          next if review.coverall.nil?

          # get user_id
          if (user_id = user_map[review.reviewer]).blank?
            user_id = (user_count += 1)
            user_map[review.reviewer] = user_id
          end

          stars = (review.coverall.to_f * 5.0 / 24.0)
          workload = review.hhard || 0
          out << [user_id, course_id, course_prof_id, stars, workload]
        end

        # new reviews
        offerings.map(&:schedules).flatten.each do |schedule|
          review = schedule.review
          next if review.blank?

          # get user_id
          if (user_id = new_user_map[schedule.user_id]).blank?
            user_id = (new_user_count += 1)
            new_user_map[schedule.user_id] = user_id
          end

          stars = review.course_rating
          workload = review.workload_rating
          out << [user_id, course_id, course_prof_id, stars, workload]
        end
      end
    end

    # output as CSV
    File.open(filename, 'w') do |f|
      f.write(out.map{|arr| arr.join("\t")}.join("\n"))
    end
  end
end

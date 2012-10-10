class PlannerController < ApplicationController
  def show
    # TODO add a "review unreviewed courses" button, and a link to each course (w/ reviews)

    if @current_user.nil?
      render :inline => "Login to see/edit your planner" and return
    end

    @now = Time.now.year
    @start_year = params[:start] || (@now - 2)
    @end_year   = params[:end]   || (@start_year + 4)
    min_year = @now < @start_year

    @years = @start_year...@end_year
    @terms = [:F,:W,:S,:X]

    # build a list of [course, offering] pairs w/ professor preloaded
    @wishlist_offerings = @current_user.wishlists.
      includes(:course => {:offerings => [:professors, :distribs]}).
      where("offerings.year" => @years).
      collect_concat{
        |w| w.course.offerings.map{ |offering| [w.course, offering] } }.
      group_by {|pair| "#{pair[1].year}#{pair[1].term}"}

    # build a hash of schedule objects w/ course, offering, professor all preloaded
    @schedule_offerings = @current_user.schedules.
      includes(:course, :offering => [:professors, :distribs]).
      where("offerings.year" => @years).
      group_by {|s| "#{s.offering.year}#{s.offering.term}"}
    
    # bundle wcult & distribs in one array
    distribs = %w{W NW CI ART LIT TMV INT SOC QDS SCI SLA TAS TLA}.each_with_object({}){|k,h| h[k]=0}
    @schedule_offerings.each{|term,scheds|
      scheds.each do |sched|
        if distribs[sched.offering.wc.try(:upcase)]
          distribs[sched.offering.wc.try(:upcase)] += 1
        end
        sched.offering.distribs.each{|d| distribs[d.distrib_abbr.try(:upcase)] += 1}
      end
    }
    # FIXME this currently over-counts distribs (really, an offering can have multiple
    # distribs but it should only COUNT for one)
    distribs["SOC"] -= 1 # subtract 1 from soc & sci/sla b/c they require 2
    distribs["SCI/SLA"] = distribs["SCI"] + distribs["SLA"] - 1
    distribs["TAS/TLA"] = distribs["TAS"] + distribs["TLA"]
    distribs["LAB"] = distribs["TLA"] + distribs["SLA"]
    %w{SCI SLA TAS TLA}.each{|k| distribs.delete(k)}
    @missing_distribs = distribs.keys.find_all{|k| distribs[k] <= 0}
  end
end

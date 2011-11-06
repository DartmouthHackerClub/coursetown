class UsersController < ApplicationController
  # GET /users
  # GET /users.xml
  def index
    @users = User.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @users }
    end
  end

  # GET /users/1
  # GET /users/1.xml
  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /users/new
  # GET /users/new.xml
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # POST /users
  # POST /users.xml
  def create
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save
        format.html { redirect_to(@user, :notice => 'User was successfully created.') }
        format.xml  { render :xml => @user, :status => :created, :location => @user }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.xml
  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to(@user, :notice => 'User was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.xml
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to(users_url) }
      format.xml  { head :ok }
    end
  end

  # GET /users/1/schedule
  def show_schedule
    @now = Time.now.year
    @start_year = params[:start] || (@now - 2)
    @end_year   = params[:end]   || (@start_year + 4)
    min_year = @now < @start_year

    @years = @start_year...@end_year
    @terms = [:F,:W,:S,:X]

    # build a list of [course, offering] pairs w/ professor preloaded
    @wishlist_offerings = @current_user.wishlists.
      includes(:course => {:offerings => :professors}).
      where("offerings.year" => @years).
      collect_concat{
        |w| w.course.offerings.map{ |offering| [w.course, offering] } }.
      group_by {|pair| "#{pair[1].year}#{pair[1].term}"}

    # build a hash of schedule objects w/ course, offering, professor all preloaded
    @schedule_offerings = @current_user.schedules.
      includes(:course, :offering => :professors).
      where("offerings.year" => @years).
      group_by {|s| "#{s.offering.year}#{s.offering.term}"}

    # bundle wcult & distribs in one array
    distribs = %w{W NW CI ART LIT TMV INT SOC QDS SCI SLA TAS TLA}.each_with_object({}){|k,h| h[k]=0}
    @schedule_offerings.each{|sched|
      if distribs[sched.offering.wc.upper] then distribs[sched.offering.wc.upper] += 1 end
      sched.offering.distribs.each{|d| distribs[d.distrib_abbr.upper] += 1}
    }
    # FIXME this currently over-counts distribs (really, an offering can have multiple
    # distribs but it can only COUNT for one)
    distribs["SOC"] -= 1 # subtract 1 from soc & sci/sla b/c they require 2
    distribs["SCI/SLA"] = distribs["SCI"] + distribs["SLA"] - 1
    distribs["TAS/TLA"] = distribs["TAS"] + distribs["TLA"]
    distribs["LAB"] = distribs["TLA"] + distribs["SLA"]
    %w{SCI SLA TAS TLA}.each{|k| distribs.delete(k)}
    @missing_distribs = distribs.keys.find_all{|k| distribs[k] <= 0}
  end
end


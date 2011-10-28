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
    @user = User.find(params[:id])
    @start_year = params[:start] ? params[:start] : (Time.new.year - 2)
    @end_year   = params[:end]   ? params[:end]   : @start_year + 4

    @years = @start_year..@end_year
    @terms = [:F,:W,:S,:X]

    fields = "number, department, title, professor, year, term, time"

    @wishlist_offerings = @user.wishlists.
      joins(:course => :offerings).
      where("offerings.year" => @years).
      select(fields).
      group_by {|course| "#{course.year}#{course.term}"}

    @schedule_offerings = @user.schedules.
      joins(:offering => :course).
      where("offerings.year" => @years).
      select(fields).
      group_by {|course| "#{course.year}#{course.term}"}

    # TODO: figure out which distribs are met/not met by SCHEDULE
  end
end

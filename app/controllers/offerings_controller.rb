class OfferingsController < ApplicationController

  # returns json, to be rendered via ajax
  def search_results
    logger.debug "==================================="
    query = params[:query] || {}

    logger.info "QUERYING IN ENVIRONMENT: #{ENV['RAILS_ENV']}"

    # process the groups
    [:distrib, :wcult, :time, :term].each do |k|
      if query[k].present?
        query[k] = query[k].each_key.to_a
      end
    end
    query.select!{|k,v| v.present?}

    logger.debug query
    logger.debug "==================================="

    @offerings = Offering.search_by_query(query).uniq(&:id)

    respond_to do |format|
      format.json do
        # TODO: WTF. If I change this to 'map do' instead of 'map {' it BREAKS! HOW?!?!
        render :json => @offerings.map { |offering|
          hash = offering.attributes
          hash[:professors] = offering.professors.map(&:attributes)
          hash[:courses] = offering.courses.map(&:attributes)
          hash
        }
      end
      format.html do
        render :layout => false
      end
    end
  end

  def search
    respond_to do |format|
      format.html # search.html.erb
    end
  end

  def simple_search
    @offerings = []
    if request.post?
      @offerings = Offering.search request.params[:q], :field_weights => {
        :department => 3, :number => 3, :professor => 2,
        :short_title => 2, :long_title => 1
      }
    end

    respond_to do |format|
      format.html
    end
  end

  # GET /offerings
  # GET /offerings.xml
  def index
    @offerings = Offering.all
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @offerings }
    end
  end

  # GET /offerings/1
  # GET /offerings/1.xml
  def show
    @offering = Offering.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @offering }
    end
  end

  # GET /offerings/new
  # GET /offerings/new.xml
  def new
    @offering = Offering.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @offering }
    end
  end

  # GET /offerings/1/edit
  def edit
    @offering = Offering.find(params[:id])
  end

  # POST /offerings
  # POST /offerings.xml
  def create
    @offering = Offering.new(params[:offering])

    respond_to do |format|
      if @offering.save
        format.html { redirect_to(@offering, :notice => 'Offering was successfully created.') }
        format.xml  { render :xml => @offering, :status => :created, :location => @offering }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @offering.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /offerings/1
  # PUT /offerings/1.xml
  def update
    @offering = Offering.find(params[:id])

    respond_to do |format|
      if @offering.update_attributes(params[:offering])
        format.html { redirect_to(@offering, :notice => 'Offering was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @offering.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /offerings/1
  # DELETE /offerings/1.xml
  def destroy
    @offering = Offering.find(params[:id])
    @offering.destroy

    respond_to do |format|
      format.html { redirect_to(offerings_url) }
      format.xml  { head :ok }
    end
  end
end

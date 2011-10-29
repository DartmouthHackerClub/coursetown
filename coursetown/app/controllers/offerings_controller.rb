class OfferingsController < ApplicationController

  def search_results
    logger.debug "==================================="
    logger.debug params[:queries]
    logger.debug "==================================="
    @offering_hashes= Offering.includes(:courses, :professors).select('*').map {
                  |offering|
                  hash = offering.attributes
                  hash[:professors] = offering.professors.map(&:attributes)
                  hash[:courses] = offering.courses.map(&:attributes)
                  hash
                  }
    render :json => @offering_hashes
  end

  def search
    respond_to do |format|
      format.html # search.html.erb
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

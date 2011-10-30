class OfferingsController < ApplicationController

  def search_results
    logger.debug "==================================="
    queries = params[:queries]
    logger.debug queries
    logger.debug "==================================="
    where_clause = {}
    if queries
        if queries.has_key? "periods"
            where_clause[:time] = queries["periods"] 
        end
        if queries.has_key? "term"
            where_clause[:term] = queries["term"] 
        end
        if queries.has_key? "year"
            where_clause[:year] = queries["year"] 
        end
        if queries.has_key? "title"
            where_clause["courses.long_title"] = queries["title"] 
        end
        if queries.has_key? "department"
            where_clause["courses.department"] = queries["department"] 
        end
        if queries.has_key? "number"
            where_clause["courses.number"] = queries["number"] 
        end
        if queries.has_key? "professors"
            where_clause["professors.name"] = queries["professors"] 
        end
        if queries.has_key? "description"
            where_clause["courses.desc"] = queries["description"] 
        end
        if queries.has_key? "wc"
            where_clause[:wc] = queries["wc"] 
        end
        #TODO: distrib, wcult, avg median, can nro
    end
    @offering_hashes= Offering.includes(:courses, :professors).where(where_clause).select('*').map {
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

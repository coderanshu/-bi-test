class LocationsController < ApplicationController
  before_filter :require_user  

  # GET /locations
  # GET /locations.json
  def index
    @locations = Location.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @locations }
    end
  end

  # GET /locations/1
  # GET /locations/1.json
  def show
    @location = Location.find(params[:id])
    @body_systems = BodySystem.all
    @patients = @location.patient_locations.first.patient unless @location.patient_locations.blank?
    @child_locations = Location.find_all_by_parent_id(@location.id)
    @context_body_system = BodySystem.find(params[:body_system]) if params[:body_system]
    @timestamp = DateTime.now.to_i

    respond_to do |format|
      format.js
      format.html # show.html.erb
      format.json { render json: @location }
    end
  end

  # GET /locations/new
  # GET /locations/new.json
  def new
    @location = Location.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @location }
    end
  end

  # GET /locations/1/edit
  def edit
    @location = Location.find(params[:id])
  end

  # POST /locations
  # POST /locations.json
  def create
    @location = Location.new(params[:location])

    respond_to do |format|
      if @location.save
        format.html { redirect_to @location, notice: 'Body system was successfully created.' }
        format.json { render json: @location, status: :created, location: @location }
      else
        format.html { render action: "new" }
        format.json { render json: @location.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /locations/1
  # PUT /locations/1.json
  def update
    @location = Location.find(params[:id])

    respond_to do |format|
      if @location.update_attributes(params[:location])
        format.html { redirect_to @location, notice: 'Body system was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @location.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /locations/1
  # DELETE /locations/1.json
  def destroy
    @location = Location.find(params[:id])
    @location.destroy

    respond_to do |format|
      format.html { redirect_to locations_url }
      format.json { head :no_content }
    end
  end

  # GET /locations/1/updated
  def updated
    @location = Location.find(params[:location_id])
    params[:timestamp] ||= "0"
    last_update = Time.zone.parse(DateTime.strptime(params[:timestamp], "%s").to_s)

    # Has the location itself been updated?
    updated = @location.updates_since?(last_update)

    # If the location has any children, have they been updated?
    children = Location.find_all_by_parent_id(@location.id)
    @updated_children = children.select{|loc| loc.updates_since?(last_update)}

    render json: {:updated => updated, :updated_children => @updated_children.map{|loc| loc.id}, :timestamp => DateTime.now.to_i}
  end
end

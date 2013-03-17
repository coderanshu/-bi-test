class BodySystemsController < ApplicationController
  before_filter :require_user

  # GET /body_systems
  # GET /body_systems.json
  def index
    @body_systems = BodySystem.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @body_systems }
    end
  end

  # GET /body_systems/1
  # GET /body_systems/1.json
  def show
    @body_system = BodySystem.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @body_system }
    end
  end

  # GET /body_systems/new
  # GET /body_systems/new.json
  def new
    @body_system = BodySystem.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @body_system }
    end
  end

  # GET /body_systems/1/edit
  def edit
    @body_system = BodySystem.find(params[:id])
  end

  # POST /body_systems
  # POST /body_systems.json
  def create
    @body_system = BodySystem.new(params[:body_system])

    respond_to do |format|
      if @body_system.save
        format.html { redirect_to @body_system, notice: 'Body system was successfully created.' }
        format.json { render json: @body_system, status: :created, location: @body_system }
      else
        format.html { render action: "new" }
        format.json { render json: @body_system.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /body_systems/1
  # PUT /body_systems/1.json
  def update
    @body_system = BodySystem.find(params[:id])

    respond_to do |format|
      if @body_system.update_attributes(params[:body_system])
        format.html { redirect_to @body_system, notice: 'Body system was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @body_system.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /body_systems/1
  # DELETE /body_systems/1.json
  def destroy
    @body_system = BodySystem.find(params[:id])
    @body_system.destroy

    respond_to do |format|
      format.html { redirect_to body_systems_url }
      format.json { head :no_content }
    end
  end
end

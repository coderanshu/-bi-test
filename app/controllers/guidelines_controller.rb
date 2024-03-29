class GuidelinesController < ApplicationController
  before_filter :require_user

  # GET /guidelines
  # GET /guidelines.json
  def index
    #@guidelines = Guideline.all
    @body_systems = BodySystem.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @guidelines }
    end
  end

  # GET /guidelines/1
  # GET /guidelines/1.json
  def show
    @guideline = Guideline.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @guideline }
    end
  end

  # GET /guidelines/new
  # GET /guidelines/new.json
  def new
    @guideline = Guideline.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @guideline }
    end
  end

  # GET /guidelines/1/edit
  def edit
    @guideline = Guideline.find(params[:id])
  end

  # POST /guidelines
  # POST /guidelines.json
  def create
    @guideline = Guideline.new(params[:guideline])

    respond_to do |format|
      if @guideline.save
        format.html { redirect_to @guideline, notice: 'Guideline was successfully created.' }
        format.json { render json: @guideline, status: :created, location: @guideline }
      else
        format.html { render action: "new" }
        format.json { render json: @guideline.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /guidelines/1
  # PUT /guidelines/1.json
  def update
    @guideline = Guideline.find(params[:id])

    respond_to do |format|
      if @guideline.update_attributes(params[:guideline])
        format.html { redirect_to @guideline, notice: 'Guideline was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @guideline.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /guidelines/1
  # DELETE /guidelines/1.json
  def destroy
    @guideline = Guideline.find(params[:id])
    @guideline.destroy

    respond_to do |format|
      format.html { redirect_to guidelines_url }
      format.json { head :no_content }
    end
  end
end

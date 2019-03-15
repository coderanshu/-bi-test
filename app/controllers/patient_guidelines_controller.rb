class PatientGuidelinesController < ApplicationController
  # GET /patient_guidelines
  # GET /patient_guidelines.json
  def index
    @patient_guidelines = PatientGuideline.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @patient_guidelines }
    end
  end

  # GET /patient_guidelines/1
  # GET /patient_guidelines/1.json
  def show
    @patient_guideline = PatientGuideline.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @patient_guideline }
    end
  end

  # GET /patient_guidelines/new
  # GET /patient_guidelines/new.json
  def new
    @patient_guideline = PatientGuideline.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @patient_guideline }
    end
  end

  # GET /patient_guidelines/1/edit
  def edit
    @patient_guideline = PatientGuideline.find(params[:id])
  end

  # POST /patient_guidelines
  # POST /patient_guidelines.json
  def create
    @patient_guideline = PatientGuideline.new(params[:patient_guideline])

    respond_to do |format|
      if @patient_guideline.save
        format.html { redirect_to @patient_guideline, notice: 'Patient guideline was successfully created.' }
        format.json { render json: @patient_guideline, status: :created, location: @patient_guideline }
      else
        format.html { render action: "new" }
        format.json { render json: @patient_guideline.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /patient_guidelines/1
  # PUT /patient_guidelines/1.json
  def update
    @patient_guideline = PatientGuideline.find(params[:id])

    respond_to do |format|
      if @patient_guideline.update_attributes(params[:patient_guideline])
        format.html { redirect_to @patient_guideline, notice: 'Patient guideline was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @patient_guideline.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /patient_guidelines/1
  # DELETE /patient_guidelines/1.json
  def destroy
    @patient_guideline = PatientGuideline.find(params[:id])
    @patient_guideline.destroy

    respond_to do |format|
      format.html { redirect_to patient_guidelines_url }
      format.json { head :no_content }
    end
  end
end

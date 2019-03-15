class PatientGuidelineStepsController < ApplicationController
  # GET /patient_guideline_steps
  # GET /patient_guideline_steps.json
  def index
    @patient_guideline_steps = PatientGuidelineStep.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @patient_guideline_steps }
    end
  end

  # GET /patient_guideline_steps/1
  # GET /patient_guideline_steps/1.json
  def show
    @patient_guideline_step = PatientGuidelineStep.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @patient_guideline_step }
    end
  end

  # GET /patient_guideline_steps/new
  # GET /patient_guideline_steps/new.json
  def new
    @patient_guideline_step = PatientGuidelineStep.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @patient_guideline_step }
    end
  end

  # GET /patient_guideline_steps/1/edit
  def edit
    @patient_guideline_step = PatientGuidelineStep.find(params[:id])
  end

  # POST /patient_guideline_steps
  # POST /patient_guideline_steps.json
  def create
    @patient_guideline_step = PatientGuidelineStep.new(params[:patient_guideline_step])

    respond_to do |format|
      if @patient_guideline_step.save
        format.html { redirect_to @patient_guideline_step, notice: 'Patient guideline step was successfully created.' }
        format.json { render json: @patient_guideline_step, status: :created, location: @patient_guideline_step }
      else
        format.html { render action: "new" }
        format.json { render json: @patient_guideline_step.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /patient_guideline_steps/1
  # PUT /patient_guideline_steps/1.json
  def update
    @patient_guideline_step = PatientGuidelineStep.find(params[:id])

    respond_to do |format|
      if @patient_guideline_step.update_attributes(params[:patient_guideline_step])
        format.html { redirect_to @patient_guideline_step, notice: 'Patient guideline step was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @patient_guideline_step.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /patient_guideline_steps/1
  # DELETE /patient_guideline_steps/1.json
  def destroy
    @patient_guideline_step = PatientGuidelineStep.find(params[:id])
    @patient_guideline_step.destroy

    respond_to do |format|
      format.html { redirect_to patient_guideline_steps_url }
      format.json { head :no_content }
    end
  end
end

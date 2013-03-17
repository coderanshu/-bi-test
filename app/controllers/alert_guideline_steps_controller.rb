class AlertGuidelineStepsController < ApplicationController
  # GET /alert_guideline_steps
  # GET /alert_guideline_steps.json
  def index
    @alert_guideline_steps = AlertGuidelineStep.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @alert_guideline_steps }
    end
  end

  # GET /alert_guideline_steps/1
  # GET /alert_guideline_steps/1.json
  def show
    @alert_guideline_step = AlertGuidelineStep.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @alert_guideline_step }
    end
  end

  # GET /alert_guideline_steps/new
  # GET /alert_guideline_steps/new.json
  def new
    @alert_guideline_step = AlertGuidelineStep.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @alert_guideline_step }
    end
  end

  # GET /alert_guideline_steps/1/edit
  def edit
    @alert_guideline_step = AlertGuidelineStep.find(params[:id])
  end

  # POST /alert_guideline_steps
  # POST /alert_guideline_steps.json
  def create
    @alert_guideline_step = AlertGuidelineStep.new(params[:alert_guideline_step])

    respond_to do |format|
      if @alert_guideline_step.save
        format.html { redirect_to @alert_guideline_step, notice: 'Alert guideline step was successfully created.' }
        format.json { render json: @alert_guideline_step, status: :created, location: @alert_guideline_step }
      else
        format.html { render action: "new" }
        format.json { render json: @alert_guideline_step.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /alert_guideline_steps/1
  # PUT /alert_guideline_steps/1.json
  def update
    @alert_guideline_step = AlertGuidelineStep.find(params[:id])

    respond_to do |format|
      if @alert_guideline_step.update_attributes(params[:alert_guideline_step])
        format.html { redirect_to @alert_guideline_step, notice: 'Alert guideline step was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @alert_guideline_step.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /alert_guideline_steps/1
  # DELETE /alert_guideline_steps/1.json
  def destroy
    @alert_guideline_step = AlertGuidelineStep.find(params[:id])
    @alert_guideline_step.destroy

    respond_to do |format|
      format.html { redirect_to alert_guideline_steps_url }
      format.json { head :no_content }
    end
  end
end

class GuidelineStepsController < ApplicationController
  # GET /guideline_steps
  # GET /guideline_steps.json
  def index
    @guideline_steps = GuidelineStep.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @guideline_steps }
    end
  end

  # GET /guideline_steps/1
  # GET /guideline_steps/1.json
  def show
    @guideline_step = GuidelineStep.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @guideline_step }
    end
  end

  # GET /guideline_steps/new
  # GET /guideline_steps/new.json
  def new
    @guideline_step = GuidelineStep.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @guideline_step }
    end
  end

  # GET /guideline_steps/1/edit
  def edit
    @guideline_step = GuidelineStep.find(params[:id])
  end

  # POST /guideline_steps
  # POST /guideline_steps.json
  def create
    @guideline_step = GuidelineStep.new(params[:guideline_step])

    respond_to do |format|
      if @guideline_step.save
        format.html { redirect_to @guideline_step, notice: 'Guideline step was successfully created.' }
        format.json { render json: @guideline_step, status: :created, location: @guideline_step }
      else
        format.html { render action: "new" }
        format.json { render json: @guideline_step.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /guideline_steps/1
  # PUT /guideline_steps/1.json
  def update
    @guideline_step = GuidelineStep.find(params[:id])

    respond_to do |format|
      if @guideline_step.update_attributes(params[:guideline_step])
        format.html { redirect_to @guideline_step, notice: 'Guideline step was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @guideline_step.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /guideline_steps/1
  # DELETE /guideline_steps/1.json
  def destroy
    @guideline_step = GuidelineStep.find(params[:id])
    @guideline_step.destroy

    respond_to do |format|
      format.html { redirect_to guideline_steps_url }
      format.json { head :no_content }
    end
  end
end

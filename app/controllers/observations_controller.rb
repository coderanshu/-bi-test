class ObservationsController < ApplicationController
  # GET /observations
  # GET /observations.json
  def index
    @observations = Observation.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @observations }
    end
  end

  # GET /observations/1
  # GET /observations/1.json
  def show
    @observation = Observation.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @observation }
    end
  end

  # GET /observations/new
  # GET /observations/new.json
  def new
    @observation = Observation.new(:patient_id => params[:patient_id])

    respond_to do |format|
      format.js { render :layout => false }
      format.html # new.html.erb
      format.json { render json: @observation }
    end
  end

  # GET /observations/1/edit
  def edit
    @observation = Observation.find(params[:id])
  end

  # POST /observations
  # POST /observations.json
  def create
    # One way to provide an observation is through a patient, question & answer
    if !params[:patient_id].blank? and !params[:question].blank? and !params[:answer].blank?
      patient_id = params[:patient_id]
      return render(:json => false) if patient_id.blank?
      patient_id = Integer(patient_id, 10)

      question = params[:question]
      answer = params[:answer]
      question = Question.find(Integer(question.split('_')[1], 10))
      @observation = Observation.find_by_patient_id_and_question_id(patient_id, question.id);
      @observation ||= Observation.new(:patient_id => patient_id, :name => question.code, :question_id => question.id, :observed_on => Time.now)
      @observation.code = question.code
      @observation.value = answer
    # The other way is to provide an observation record
    elsif !params[:observation].blank?
      @observation = Observation.new(params[:observation])
    else
      return render :json => false
    end

    #@location = Location.new(params[:location])

    #respond_to do |format|
    #  if @location.save
    #    format.html { redirect_to @location, notice: 'Body system was successfully created.' }
    #    format.json { render json: @location, status: :created, location: @location }
    #  else
    #    format.html { render action: "new" }
    #    format.json { render json: @location.errors, status: :unprocessable_entity }
    #  end
    #end
    result = @observation.save

    # If the observation saved, see if it was related at all to a patient guideline step
    # If so, check if we are still missing data for that step
    #if result
    #  @observation.clear_guideline_steps
    #end

    render :json => result
  end

  # DELETE /observations/1
  # DELETE /observations/1.json
  def destroy
    @observation = Observation.find(params[:id])
    @observation.destroy

    respond_to do |format|
      format.html { redirect_to observations_url }
      format.json { head :no_content }
    end
  end
end


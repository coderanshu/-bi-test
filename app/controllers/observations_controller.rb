class ObservationsController < ApplicationController
  # POST /observations
  # POST /observations.json
  def create
    # We need a patient, a question, and an answer
    patient = params[:patient]
    question = params[:question]
    answer = params[:answer]

    if patient.blank? or question.blank? or answer.blank?
      return render :json => false
    end

    patient_id = Integer(patient, 10)
    question = Question.find(Integer(question.split('_')[1], 10))

    observation = Observation.find_by_patient_id_and_question_id(patient_id, question.id);
    observation ||= Observation.new(:patient_id => patient_id, :name => question.code, :question_id => question.id)
    observation.value = answer

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

    render :json => observation.save
  end
end

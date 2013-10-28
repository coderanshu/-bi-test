class PatientLocationsController < ApplicationController
  def index
  end

  def new
  end

  def create
    save_patient_location
  end

  def edit
  end

  def update
    save_patient_location
  end

  private
  def save_patient_location
    patient_location = params[:patient_location]
    # Do we alreayd have a record for this patient?
    existing_record = PatientLocation.active.find_by_patient_id(patient_location[:patient_id])
    if existing_record.blank?
      unless patient_location[:location_id] == 0
        patient_location[:status] = 1
        saved = PatientLocation.create(patient_location)
      end
    elsif patient_location[:location_id] == "0"
      existing_record.update_attributes(:status => 0)
    else
      saved = existing_record.update_attributes(:location_id => patient_location[:location_id])
    end
    render :json => { :response => saved }
  end
end

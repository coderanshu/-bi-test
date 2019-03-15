class ChecklistsController < ApplicationController
  def new
    @patient = Patient.find(params[:patient_id])
    render :layout => false
  end
end

class PatientChecklistsController < ApplicationController
  # GET /patient_flowsheet_rows/new
  # GET /patient_flowsheet_rows/new.json
  def new
    @patient_checklist = PatientChecklist.where("patient_id = ? AND checklist_id = ? AND DATE(date) = ?", 
      params[:patient_id], params[:checklist_id], Time.now.to_date).first
    @patient_checklist ||= PatientChecklist.create(:patient_id => params[:patient_id], :checklist_id => params[:checklist_id], :date => Time.now)
    @checklist = Checklist.find(@patient_checklist.checklist_id)
    @patient = Patient.find(params[:patient_id]) unless params[:patient_id].blank?
    respond_to do |format|
      format.html { render "checklists/edit" }
      format.json { render json: @patient_checklist }
    end
  end
end

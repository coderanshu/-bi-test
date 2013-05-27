class PatientsController < ApplicationController
  before_filter :require_user

  # GET /patients
  # GET /patients.json
  def index
    @q = Patient.search(params[:q])
    @patients = @q.result
#    @patients = @patients.all

    respond_to do |format|
      format.html # index.html.erb
      format.js
      format.json { render json: @patients }
    end
  end

  # GET /patients/1
  # GET /patients/1.json
  def show
    @patient = Patient.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @patient }
    end
  end

  # GET /patients/new
  # GET /patients/new.json
  def new
    @patient = Patient.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @patient }
    end
  end

  # GET /patients/1/edit
  def edit
    @patient = Patient.find(params[:id])
  end

  # POST /patients
  # POST /patients.json
  def create
    @patient = Patient.new(params[:patient])

    respond_to do |format|
      if @patient.save
        format.html { redirect_to @patient, notice: 'Patient was successfully created.' }
        format.json { render json: @patient, status: :created, location: @patient }
      else
        format.html { render action: "new" }
        format.json { render json: @patient.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /patients/1
  # PUT /patients/1.json
  def update
    @patient = Patient.find(params[:id])

    respond_to do |format|
      if @patient.update_attributes(params[:patient])
        format.html { redirect_to @patient, notice: 'Patient was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @patient.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /patients/1
  # DELETE /patients/1.json
  def destroy
    @patient = Patient.find(params[:id])
    @patient.destroy

    respond_to do |format|
      format.html { redirect_to patients_url }
      format.json { head :no_content }
    end
  end

  def flowsheet
    @patient = Patient.find(params[:id])
    @flowsheet = PatientFlowsheet.find_by_patient_id_and_template(@patient.id, params[:template])
    if @flowsheet.nil?  
      @flowsheet = PatientFlowsheet.create(:patient_id => @patient.id, :template => params[:template])
    end
  end

  def checklist
    @patient = Patient.find(params[:id])
    @flowsheet = PatientFlowsheet.find_by_patient_id_and_template(@patient.id, params[:template])
    if @flowsheet.nil?  
      @flowsheet = PatientFlowsheet.create(:patient_id => @patient.id, :template => params[:template])
    end
  end
end

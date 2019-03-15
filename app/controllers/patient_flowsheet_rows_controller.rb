class PatientFlowsheetRowsController < ApplicationController
  # GET /patient_flowsheet_rows/1
  # GET /patient_flowsheet_rows/1.json
  def show
    @patient_flowsheet_row = PatientFlowsheetRow.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @patient_flowsheet_row }
    end
  end

  # GET /patient_flowsheet_rows/new
  # GET /patient_flowsheet_rows/new.json
  def new
    @patient_flowsheet_row = PatientFlowsheetRow.new(:patient_flowsheet_id => params[:patient_flowsheet_id])
    @patient_id = params[:patient_id] unless params[:patient_id].blank?
    respond_to do |format|
      format.js { render :partial => "flowsheets/#{params[:template]}_row" }
      format.json { render json: @patient_flowsheet_row }
    end
  end

  # GET /patient_flowsheet_rows/1/edit
  def edit
    @patient_flowsheet_row = PatientFlowsheetRow.find(params[:id])
    @patient_flowsheet_row.reload
    @patient_id = @patient_flowsheet_row.patient_flowsheet.patient_id
    render :partial => "flowsheets/#{@patient_flowsheet_row.patient_flowsheet.template}_row"
  end

  # POST /patient_flowsheet_rows
  # POST /patient_flowsheet_rows.json
  def create
    # Protect against create being called for an existing flowsheet row
    if params[:observation].blank? or params[:observation][:patient_flowsheet_row_id].blank?
      @patient_flowsheet_row = PatientFlowsheetRow.new(:patient_flowsheet_id => params["patient_flowsheet_id"])
      result = @patient_flowsheet_row.save
    else
      @patient_flowsheet_row = PatientFlowsheetRow.find(params[:observation][:patient_flowsheet_row_id])
      result = !(@patient_flowsheet_row.blank?)
    end

    observation = save_observation(@patient_flowsheet_row)
    respond_to do |format|
      if observation.blank?
        format.json { head :no_content }
      elsif result
        format.json { render json: {:observation_id => observation.id, :flowsheet_row_id => @patient_flowsheet_row.id}, status: :created, location: @patient_flowsheet_row }
      else
        format.json { render json: @patient_flowsheet_row.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /patient_flowsheet_rows/1
  # PUT /patient_flowsheet_rows/1.json
  def update
    @patient_flowsheet_row = PatientFlowsheetRow.find(params[:id])
    observation = save_observation(@patient_flowsheet_row)
    respond_to do |format|
      if observation.blank?
        format.json { head :no_content }
      elsif @patient_flowsheet_row.update_attributes(params[:patient_flowsheet_row])
        format.json { render json: {:observation_id => observation.id, :flowsheet_row_id => @patient_flowsheet_row.id}, status: :created, location: @patient_flowsheet_row }
        #format.json { render json: @patient_flowsheet_row, status: :created, location: @patient_flowsheet_row }
      else
        format.json { render json: @patient_flowsheet_row.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /patient_flowsheet_rows/1
  # DELETE /patient_flowsheet_rows/1.json
  def destroy
    @patient_flowsheet_row = PatientFlowsheetRow.find(params[:id])
    @patient_flowsheet_row.destroy

    respond_to do |format|
      format.html { redirect_to patient_flowsheet_rows_url }
      format.json { head :no_content }
    end
  end

private
  def save_observation patient_flowsheet_row
    patient_id = params[:patient_id]
    obs = Observation.new(params[:observation])
    obs.observed_on = DateTime.strptime(params[:observation][:observed_on], "%m/%d/%Y %H:%M %P")

    existing_obs = Observation.find_by_id(obs.id) unless obs.id.blank?
    existing_obs = Observation.find_by_patient_id_and_patient_flowsheet_row_id_and_code(patient_id, @patient_flowsheet_row.id, obs.code) if existing_obs.blank? and !obs.code.blank?
    existing_obs = Observation.find_by_patient_id_and_patient_flowsheet_row_id_and_name(patient_id, @patient_flowsheet_row.id, obs.name) if existing_obs.blank? and !obs.name.blank?

    if existing_obs.blank?
      unless obs.value.blank?
        obs.patient_flowsheet_row_id = patient_flowsheet_row.id
        obs.save!
        obs
      else
        nil
      end
    else
      if obs.value.blank?
        existing_obs.destroy
        nil
      else
        existing_obs.update_attributes(:value => obs.value, :observed_on => obs.observed_on)  # Limit the attributes we will update
        existing_obs
      end
    end
  end
end

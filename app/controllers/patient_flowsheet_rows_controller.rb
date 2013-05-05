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
    @patient_flowsheet_row = PatientFlowsheetRow.new(:patient_flowsheet_id => params["patient_flowsheet_id"])
    result = @patient_flowsheet_row.save
    extract_observations
    respond_to do |format|
      if result
        format.json { render json: @patient_flowsheet_row, status: :created, location: @patient_flowsheet_row }
      else
        format.json { render json: @patient_flowsheet_row.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /patient_flowsheet_rows/1
  # PUT /patient_flowsheet_rows/1.json
  def update
    @patient_flowsheet_row = PatientFlowsheetRow.find(params[:id])
    extract_observations
    respond_to do |format|
      if @patient_flowsheet_row.update_attributes(params[:patient_flowsheet_row])
        format.json { head :no_content }
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
  def extract_observations
    # Data is stored in an array of Hashes
    patient_id = params.find { |par| par[0] == "patient_id" }[1]
    params.each do |item|
      obs_name = item[0].gsub(/(obs_.*)(_[\d]*)/, '\1')
      next unless obs_name.start_with?("obs_")
      obs = Observation.find_by_patient_id_and_patient_flowsheet_row_id_and_code(patient_id, @patient_flowsheet_row.id, obs_name)
      if obs.blank?
        Observation.create(:name => obs_name, :value => item[1], :patient_id => patient_id, :patient_flowsheet_row_id => @patient_flowsheet_row.id, :observed_on => Time.now, :code => obs_name)
      elsif obs.value != item[1]
        obs.update_attributes(:value => item[1])
      end
    end
  end
end

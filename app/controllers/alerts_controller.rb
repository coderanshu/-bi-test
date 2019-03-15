class AlertsController < ApplicationController
  # GET /alerts
  # GET /alerts.json
  def index
    @alerts = Alert.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @alerts }
    end
  end

  # GET /alerts/1
  # GET /alerts/1.json
  def show
    @alert = Alert.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @alert }
    end
  end

  # GET /alerts/new
  # GET /alerts/new.json
  def new
    @alert = Alert.new(:patient_id => params[:patient_id])

    respond_to do |format|
      format.js { render :layout => false }
      format.html # new.html.erb
      format.json { render json: @alert }
    end
  end

  # GET /alerts/1/edit
  def edit
    @alert = Alert.find(params[:id])
  end

  # POST /alerts
  # POST /alerts.json
  def create
    if !params[:alert].blank?
      @alert = Alert.new(params[:alert])
      @alert.status ||= 1
    else
      return render :json => false
    end
    result = @alert.save
    render :json => result
  end

  def update
    @alert = Alert.find(params[:id])

    if params[:alert][:status].to_i == Alert::DEFERRED
      params[:alert][:expires_on] ||= Time.now + 3.hour.to_i
      params[:alert][:severity] = 3
    elsif params[:alert][:status].to_i == Alert::ACKNOWLEDGED
      params[:alert][:acknowledged_on] ||= Time.now
      params[:alert][:severity] = 3
    end

    result = @alert.update_attributes(params[:alert])
    if params[:alert][:status].to_i == Alert::ADD_TO_DX_LIST
      problem = Problem.find_by_alert_id_and_status(@alert.id, 'Possible')
      problem.update_attributes(:status => 'Diagnosis') unless problem.blank?
    end

    respond_to do |format|
      if result
        format.html { redirect_to @alert, notice: 'Alert was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @alert.errors, status: :unprocessable_entity }
      end
    end
  end

  def action
    @alert = Alert.find(params[:id])
    guideline_action = GuidelineAction.find(params[:alert][:action_id])
    patient_guideline = PatientGuideline.find_by_guideline_id_and_patient_id(guideline_action.guideline.id, @alert.patient_id)
    # Check if there is already a response
    ### REPLACE WITH CALL TO GUIDELINE MANAGER
    existing_action = PatientGuidelineAction.find_by_patient_id_and_guideline_action_id(@alert.patient_id, guideline_action.id)
    if existing_action.blank?
      PatientGuidelineAction.create(:patient_id => @alert.patient_id, :guideline_action_id => guideline_action.id, :action => params[:alert][:action], :acted_on => Time.now, :patient_guideline_id => patient_guideline.id)
    elsif existing_action.action.blank?
      existing_action.update_attributes(:action => params[:alert][:action])
    end
    ###
    respond_to do |format|
        format.json { head :no_content }
    end
  end

  # DELETE /alerts/1
  # DELETE /alerts/1.json
  def destroy
    @alert = Alert.find(params[:id])
    @alert.destroy

    respond_to do |format|
      format.html { redirect_to alerts_url }
      format.json { head :no_content }
    end
  end
end

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
    result = @alert.save
    render :json => result
  end

  def update
    @alert = Alert.find(params[:id])

    if params[:alert][:status].to_i == Alert::DEFERRED
      params[:alert][:expires_on] ||= Time.now + 3.hour.to_i
      params[:alert][:severity] = 3
    end

    respond_to do |format|
      if @alert.update_attributes(params[:alert])
        format.html { redirect_to @alert, notice: 'Alert was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @alert.errors, status: :unprocessable_entity }
      end
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

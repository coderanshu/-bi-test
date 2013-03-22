class ValueSetsController < ApplicationController
  # GET /value_sets
  # GET /value_sets.json
  def index
    @value_sets = ValueSet.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @value_sets }
    end
  end

  # GET /value_sets/1
  # GET /value_sets/1.json
  def show
    @value_set = ValueSet.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @value_set }
    end
  end

  # GET /value_sets/new
  # GET /value_sets/new.json
  def new
    @value_set = ValueSet.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @value_set }
    end
  end

  # GET /value_sets/1/edit
  def edit
    @value_set = ValueSet.find(params[:id])
  end

  # POST /value_sets
  # POST /value_sets.json
  def create
    @value_set = ValueSet.new(params[:value_set])

    respond_to do |format|
      if @value_set.save
        format.html { redirect_to @value_set, notice: 'Value set was successfully created.' }
        format.json { render json: @value_set, status: :created, location: @value_set }
      else
        format.html { render action: "new" }
        format.json { render json: @value_set.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /value_sets/1
  # PUT /value_sets/1.json
  def update
    @value_set = ValueSet.find(params[:id])

    respond_to do |format|
      if @value_set.update_attributes(params[:value_set])
        format.html { redirect_to @value_set, notice: 'Value set was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @value_set.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /value_sets/1
  # DELETE /value_sets/1.json
  def destroy
    @value_set = ValueSet.find(params[:id])
    @value_set.destroy

    respond_to do |format|
      format.html { redirect_to value_sets_url }
      format.json { head :no_content }
    end
  end
end

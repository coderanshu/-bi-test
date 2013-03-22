class ValueSetMembersController < ApplicationController
  # GET /value_set_members
  # GET /value_set_members.json
  def index
    @value_set_members = ValueSetMember.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @value_set_members }
    end
  end

  # GET /value_set_members/1
  # GET /value_set_members/1.json
  def show
    @value_set_member = ValueSetMember.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @value_set_member }
    end
  end

  # GET /value_set_members/new
  # GET /value_set_members/new.json
  def new
    @value_set_member = ValueSetMember.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @value_set_member }
    end
  end

  # GET /value_set_members/1/edit
  def edit
    @value_set_member = ValueSetMember.find(params[:id])
  end

  # POST /value_set_members
  # POST /value_set_members.json
  def create
    @value_set_member = ValueSetMember.new(params[:value_set_member])

    respond_to do |format|
      if @value_set_member.save
        format.html { redirect_to @value_set_member, notice: 'Value set member was successfully created.' }
        format.json { render json: @value_set_member, status: :created, location: @value_set_member }
      else
        format.html { render action: "new" }
        format.json { render json: @value_set_member.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /value_set_members/1
  # PUT /value_set_members/1.json
  def update
    @value_set_member = ValueSetMember.find(params[:id])

    respond_to do |format|
      if @value_set_member.update_attributes(params[:value_set_member])
        format.html { redirect_to @value_set_member, notice: 'Value set member was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @value_set_member.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /value_set_members/1
  # DELETE /value_set_members/1.json
  def destroy
    @value_set_member = ValueSetMember.find(params[:id])
    @value_set_member.destroy

    respond_to do |format|
      format.html { redirect_to value_set_members_url }
      format.json { head :no_content }
    end
  end
end

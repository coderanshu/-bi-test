class ProblemsController < ApplicationController
  def update
    @problem = Problem.find(params[:id])

    if params[:problem][:status] == 'Active'
    elsif params[:problem][:status] == 'Possible'
    elsif params[:problem][:status] == 'Remove'
    elsif params[:problem][:status] == 'Resolved'
    elsif params[:problem][:status] == 'NotApplicable'
    end

    respond_to do |format|
      if @problem.update_attributes(params[:problem])
        format.html { redirect_to @problem, notice: 'Problem was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @problem.errors, status: :unprocessable_entity }
      end
    end
  end
end

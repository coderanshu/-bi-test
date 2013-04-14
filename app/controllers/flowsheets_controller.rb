class FlowsheetsController < ApplicationController
  def vac_row
    respond_to do |format|
      format.js { render :layout => false }
      format.html # new.html.erb
    end
  end

  def update_vac_row
  end
end

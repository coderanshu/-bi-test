class HomeController < ApplicationController
  def index
    @location = Location.find_by_location_type(1)
    @body_systems = BodySystem.all
    @q = Patient.search(params[:q])
  end
end

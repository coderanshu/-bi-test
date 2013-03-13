class HomeController < ApplicationController
  def index
    @location = Location.find_by_location_type(1)
  end
end

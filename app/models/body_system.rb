class BodySystem < ActiveRecord::Base
  has_many :alerts
  attr_accessible :name, :order

  def code
    name.downcase.gsub(/\s/, '_')
  end
end

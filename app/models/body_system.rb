class BodySystem < ActiveRecord::Base
  has_many :alerts
  attr_accessible :name, :order

  default_scope order('body_systems.[order]')

  def code
    name.downcase.gsub(/\s/, '_')
  end
end

# == Schema Information
#
# Table name: body_systems
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  order      :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class BodySystem < ActiveRecord::Base
  has_many :alerts
  attr_accessible :name, :order

  default_scope order('body_systems.[order]')

  def code
    name.downcase.gsub(/\s/, '_')
  end
end

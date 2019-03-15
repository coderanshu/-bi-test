require 'guideline'
require 'guideline_step'

class RetireOldCardiacGuidelines < ActiveRecord::Migration
  def up
    set_guideline_status "CARDIAC_AHF", "retired"
    set_guideline_status "CARDIAC_ALF", "retired"
  end

  def down
    set_guideline_status "CARDIAC_AHF", "active"
    set_guideline_status "CARDIAC_ALF", "active"
  end

  def set_guideline_status guideline_code, status
    guideline = Guideline.find_by_code(guideline_code)
    unless guideline.nil?
      GuidelineStep.find_all_by_guideline_id(guideline.id).each { |x| x.update_attributes(:status => status) }
      guideline.update_attributes(:status => status)
    end
  end
end

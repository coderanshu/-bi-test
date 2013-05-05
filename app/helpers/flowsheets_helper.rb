module FlowsheetsHelper
  def get_value_for_field field
    observation = @observations.find{|obs| obs.code == field}
    return "" if observation.blank?
    observation.value
  end
end

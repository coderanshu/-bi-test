module FlowsheetsHelper
  def get_observation_for_field field
    observation = @observations.find{|obs| obs.code == field}
    observation = @observations.find{|obs| obs.name == field} if observation.blank?
  end

  def get_value_for_field field, observation
    return "" if observation.blank?
    observation.value
  end

  def get_id_for_field field, observation
    return "" if observation.blank?
    observation.id
  end
end

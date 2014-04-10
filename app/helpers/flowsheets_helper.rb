module FlowsheetsHelper
  def get_observation_for_field field
    @observations.find{|obs| obs.code == field}
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

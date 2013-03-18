class TestMessageController < ApplicationController
  before_filter :require_user

  def index
    id = params[:msg_id]
    case id
    when "1"
      Alert.create(:body_system_id => 5, :patient_id => 1, :alert_type => 1, :severity => 3, :description => "2 consecutive borderline creatinine result", :status => 1)
    when "2"
      Alert.create(:body_system_id => 5, :patient_id => 2, :alert_type => 1, :severity => 3, :description => "2 consecutive borderline creatinine result", :status => 1)
    end
  end
end

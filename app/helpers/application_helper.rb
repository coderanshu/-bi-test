module ApplicationHelper
  def format_date_time timestamp
  	return "" if timestamp.blank?
    timestamp.strftime('%m/%d/%Y %H:%M')
  end
end

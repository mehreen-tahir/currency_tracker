module ApplicationHelper
  def alert_class(flash_type)
    klass_name = case flash_type.to_sym
    when :success
      'alert-success'
    when :alert
      'alert-danger'
    end

    "alert #{klass_name} alert-dismissible fade show"
  end

  def datetime_wrapper(datetime)
    datetime.strftime("%A - %d %B %Y at %I:%M:%S %p") rescue nil
  end
end

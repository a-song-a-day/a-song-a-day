module QueueCountClassHelper
  def queue_count_class(count)
    if count > 2
      return "text-success"
    elsif count > 0
      return "text-warning"
    else
      return "text-danger"
    end
  end
end

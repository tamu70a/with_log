module BuddyHelper
  def buddy_time_slot(user)
    time = user.last_buddy_updated_at || Time.current
    hour = time.in_time_zone("Asia/Tokyo").hour

    case hour
    when 5..10
      :morning
    when 11..17
      :daytime
    else
      :night
    end
  end

  def buddy_image_path(user)
    case buddy_time_slot(user)
    when :morning
      "buddy/morning.png"
    when :daytime
      "buddy/noon.png"
    else
      "buddy/night.png"
    end
  end
end

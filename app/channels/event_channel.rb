class EventChannel < ApplicationCable::Channel
  def subscribed
    stream_from "public_event_channel"
    stream_from "#{current_user.id}_event_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end

class RoomChannel < ApplicationCable::Channel
  def subscribed
    stream_from "room_channel" 
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def speak(data)
    ActionCable.server.broadcast 'room_channel', html: data['html'], user_or_hairdresser: data["user_or_hairdresser"], room_token: data["room_token"], message: data["message"], img_html: data["img_html"]
  end

  def self.notice(data)
    ActionCable.server.broadcast "room_channel", user_or_hairdresser: data["user_or_hairdresser"], room_token: data["room_token"]
  end

end

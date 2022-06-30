class ImportPlatformCustomersChannel < ApplicationCable::Channel
  def subscribed
    stream_from "ImportPlatformCustomersChannel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end

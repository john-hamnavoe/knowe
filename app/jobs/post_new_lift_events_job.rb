class PostNewLiftEventsJob < ApplicationJob
  discard_on StandardError # discard if fails
  queue_as :default

  def perform(user, project)
    lift_event_adapator = PlatformLiftEventAdapter.new(user, project)
    lift_events = PlatformLiftEventRepository.new(user, project).all({ guid: nil })
    lift_events.each do |lift_event|
      lift_event_adapator.create(lift_event)
    end
  end
end
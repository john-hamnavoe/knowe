# Task to create lift events for posting into test system

task :post_lift_events => :environment do
  project_id = 1
  user_id = 1

  project = Project.find(project_id)
  user = User.find(user_id)  
  
  lift_event_adapator = PlatformLiftEventAdapter.new(user, project)
  lift_events = PlatformLiftEventRepository.new(user, project).all({ guid: nil })
  lift_events.each_with_index do |lift_event, index|
    lift_event_adapator.create(lift_event)
    print "." if index % 100 == 0
  end
end



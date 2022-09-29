class PutPlatformUpdatesJob < ApplicationJob
  discard_on StandardError # discard if fails
  queue_as :default

  def perform(user, project)
    repo = PlatformPutRepository.new(user)
    unsent_puts = repo.unsent
    unsent_puts.each do |put|
      platform_resource =  "#{put.class_name}Repository".constantize.new(user,project).load_by_guid(put.guid)
      restrict_to_attributes = put.restrict_to_attributes.split(',').map(&:to_sym)
      response = "#{put.class_name}Adapter".constantize.new(user, project).update(platform_resource, *restrict_to_attributes)
      repo.update_last_response(put.id, response.code, response.body)
    end
  end
end

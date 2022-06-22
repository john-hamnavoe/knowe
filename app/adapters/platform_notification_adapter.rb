# frozen_string_literal: true

class PlatformNotificationAdapter < ApplicationAdapter
  def fetch
    import_notifications(project.sms_third_party_key, "sms") if project.sms_third_party_key.present?
    import_notifications(project.email_third_party_key, "email") if project.email_third_party_key.present?
  end

  private

  def import_notifications(third_party_key, notification_class)
    bookmark = bookmark_repo.find("PlatformNotification")
    page = bookmark&.page || 0

    loop do
      response = platform_client.query("integrator/erp/comms/notifications?max=200&page=#{page}&filter=ThirdPartyKey eq '#{third_party_key}'&order=GeneratedTimeStamp")

      if response.success?
        response_data = JSON.parse("[#{response.body}]", symbolize_names: true)[0]
        records = []
        response_data[:resource].each do |notification|
          records << { project_id: project.id,
                       guid: notification[:resource][:GUID],
                       notification_class: notification_class,
                       generated_time_stamp: notification[:resource][:GeneratedTimestamp],
                       subject: notification[:resource][:Subject],
                       message: notification[:resource][:Message],
                       is_sent: notification[:resource][:IsSent],
                       destination_address: notification[:resource][:DestinationAddress] }
        end
        platform_notification_repository.import(records)
      end

      break if !response.success? || response_data[:resource].empty?

      page += 1
    end
    bookmark_repo.create_or_update_page("PlatformNotification", page)
  end

  def platform_notification_repository
    @platform_notification_repository ||= PlatformNotificationRepository.new(nil, project)
  end

  def bookmark_repo
    @bookmark_repo ||= PlatformBookmarkRepository.new(user, project)
  end
end

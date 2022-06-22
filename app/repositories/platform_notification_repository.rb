# frozen_string_literal: true

class PlatformNotificationRepository < ApplicationRepository
  def all(args = {}, order_by = "subject", direction = "asc")
    query = PlatformNotification.where(project: project).where(args)

    query.order(order_by => direction)
  end

  def load(id)
    PlatformNotification.find_by(id: id, project: project)
  end

  def load_by_guid(guid)
    PlatformNotification.find_by(guid: guid, project: project)
  end

  def import(records)
    PlatformNotification.import records, on_duplicate_key_update: { conflict_target: [:guid, :project_id], columns: [:destination_address, :generated_time_stamp, :is_sent, :subject, :message, :notification_class] }, returning: :guid
  end
end

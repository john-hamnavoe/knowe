# frozen_string_literal: true

class PlatformScheduleRepository < ApplicationRepository
  def all(args = {}, order_by = "scheduled_date", direction = "desc")
    query = PlatformSchedule.eager_load(:platform_company_outlet).where( project: project).where(args)

    query.order(order_by => direction)
  end

  def load_by_guid(guid)
    PlatformSchedule.find_by(guid: guid,  project: project)
  end

  def import(records)
    PlatformSchedule.import records, on_duplicate_key_update: { conflict_target: [:guid, :project_id], columns: [:scheduled_date, :is_completed, :is_container_schedule, :is_for_vehicle, :is_manifest_completed, :is_manifest_exported,:is_manifest_exported_failed,                                                                                           
                                                                                                                 :notes, :description, :leave_yard_time, :return_yard_time, :related_vehicle_guid, :related_user_driver_guid, :platform_vehicle_id, :platform_company_outlet_id] }, returning: :guid
  end
end


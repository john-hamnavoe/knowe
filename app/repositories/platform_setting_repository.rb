# frozen_string_literal: true

class PlatformSettingRepository < ApplicationRepository
  def all(args = {}, order_by = "position", direction = "asc")
    query = PlatformSetting.where(project: project).where(args)

    query.order(order_by => direction)
  end

  def create(params)
    setting = PlatformSetting.new(params)
    setting.project = project
    setting.save
    setting
  end

  def update(id, params)
    setting = PlatformSetting.find_by(id: id)
    setting&.update(params)
    setting
  end

  def update_last_response(class_name, response_code)
    setting = PlatformSetting.find_by(class_name: class_name, project: project)
    return nil unless setting

    row_count = class_name.constantize.where(project: project).count
    setting.update(last_response_code: response_code, last_request: Time.zone.now, rows: row_count)
    setting
  end

  def load(id)
    PlatformSetting.find_by(id: id)
  end
end

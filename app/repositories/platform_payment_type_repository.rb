# frozen_string_literal: true

class PlatformPaymentTypeRepository < ApplicationRepository
  def all(args = {}, order_by = "description", direction = "asc")
    query = PlatformPaymentType.where( project: project).where(args)
    

    query.order(order_by => direction)
  end

  def load_by_guid(guid)
    PlatformPaymentType.find_by(guid: guid,  project: project)
  end

  def import(records)
    PlatformPaymentType.import records, on_duplicate_key_update: { conflict_target: [:guid, :project_id], columns: [:description, :is_direct_debit, :is_cash, :is_auto_pay, :is_card, :is_electronic,
                                                                                                                                      :is_cheque, :accept_low_value, :is_system_payment, :can_mark_as_bad, :is_negative, 
                                                                                                                                      :is_for_lodgement, :short_code, :is_deleted] }, returning: :guid
  end
end

# frozen_string_literal: true

class PlatformPaymentTypeAdapter < ApplicationAdapter
  def fetch
    import_payment_types
  end

  private

  def import_payment_types
    response = platform_client.query("integrator/erp/lists/paymentTypes")

    if response.success?
      response_data = JSON.parse("[#{response.body}]", symbolize_names: true)[0]
      records = []
      response_data[:resource].each do |payment_type|
        records << { project_id: project.id,
                     guid: payment_type[:resource][:GUID],
                     description: payment_type[:resource][:Description],
                     is_direct_debit: payment_type[:resource][:IsDirectDebit],
                     is_cash: payment_type[:resource][:IsCash],
                     is_auto_pay: payment_type[:resource][:IsAutoPay],
                     is_card: payment_type[:resource][:IsCard],
                     is_electronic: payment_type[:resource][:IsElectronic],
                     is_cheque: payment_type[:resource][:IsCheque],
                     accept_low_value: payment_type[:resource][:AcceptLowValue],
                     is_system_payment: payment_type[:resource][:IsSystemPayment],
                     can_mark_as_bad: payment_type[:resource][:CanMarkAsBad],
                     is_negative: payment_type[:resource][:IsNegative],
                     is_for_lodgement: payment_type[:resource][:IsForLodgement],
                     short_code: payment_type[:resource][:ShortCode],
                     is_deleted: payment_type[:resource][:IsDeleted] }
      end
      PlatformPaymentTypeRepository.new(nil, project).import(records)
    end

    PlatformSettingRepository.new(nil, project).update_last_response("PlatformPaymentType", response.code)
  end
end

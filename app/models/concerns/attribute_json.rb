# frozen_string_literal: true

module AttributeJson
  extend ActiveSupport::Concern

  def build_attributes_json(attributes)
    build = {}
    attributes.each do |attribute|
      value = self[attribute]
      value = value.to_f if value.is_a?(BigDecimal)
      build = build.merge({ attribute.to_s.camelize => value })
    end
    build
  end
end

# frozen_string_literal: true

require "test_helper"

class PlatformDocumentDeliveryTypeAdapterTest < ActionDispatch::IntegrationTest

  def setup
    @bob = users(:bob)
    @vcr = projects(:vcr)
  end

  test "fetch" do
    VCR.use_cassette("platform document delivery type fetch") do
      # Perform initial fetch
      assert_difference "PlatformDocumentDeliveryType.count", +6 do
        PlatformDocumentDeliveryTypeAdapter.new(@bob, @vcr).fetch
      end
    end
  end
end

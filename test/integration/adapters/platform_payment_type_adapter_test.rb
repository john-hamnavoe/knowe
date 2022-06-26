# frozen_string_literal: true

require "test_helper"

class PlatformPaymentTypeAdapterTest < ActionDispatch::IntegrationTest

  def setup
    @bob = users(:bob)
    @vcr = projects(:vcr)
  end

  test "fetch" do
    VCR.use_cassette("platform payment type fetch") do
      # Perform initial fetch
      assert_difference "PlatformPaymentType.count", +10 do
        PlatformPaymentTypeAdapter.new(@bob, @vcr).fetch
      end

      # Perform second fetch with new item
      assert_difference "PlatformPaymentType.count", +1 do
        PlatformPaymentTypeAdapter.new(@bob, @vcr).fetch
      end
    end
  end
end

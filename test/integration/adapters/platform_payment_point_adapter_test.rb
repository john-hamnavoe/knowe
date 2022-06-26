# frozen_string_literal: true

require "test_helper"

class PlatformPaymentPointAdapterTest < ActionDispatch::IntegrationTest

  def setup
    @bob = users(:bob)
    @vcr = projects(:vcr)
  end

  test "fetch" do
    VCR.use_cassette("platform payment point fetch") do
      # Perform initial fetch
      assert_difference "PlatformPaymentPoint.count", +2 do
        PlatformPaymentPointAdapter.new(@bob, @vcr).fetch
      end

      # Perform second fetch with new item 
      assert_difference "PlatformPaymentPoint.count", +1 do
        PlatformPaymentPointAdapter.new(@bob, @vcr).fetch
      end
    end
  end
end

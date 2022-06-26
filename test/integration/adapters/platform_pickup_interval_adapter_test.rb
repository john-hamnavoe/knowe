# frozen_string_literal: true

require "test_helper"

class PlatformPickupIntervalAdapterTest < ActionDispatch::IntegrationTest

  def setup
    @bob = users(:bob)
    @vcr = projects(:vcr)
  end

  test "fetch" do
    VCR.use_cassette("platform pickup interval fetch") do
      # Perform initial fetch
      assert_difference "PlatformPickupInterval.count", +11 do
        PlatformPickupIntervalAdapter.new(@bob, @vcr).fetch
      end

      # Perform second fetch with new item 
      assert_difference "PlatformPickupInterval.count", +1 do
        PlatformPickupIntervalAdapter.new(@bob, @vcr).fetch
      end
    end
  end
end

# frozen_string_literal: true

require "test_helper"

class PlatformZoneAdapterTest < ActionDispatch::IntegrationTest

  def setup
    @bob = users(:bob)
    @vcr = projects(:vcr)
  end

  test "fetch" do
    VCR.use_cassette("platform zone fetch") do
      # Perform initial fetch
      assert_difference "PlatformZone.count", +16 do
        PlatformZoneAdapter.new(@bob, @vcr).fetch
      end

      # Perform second fetch
      assert_difference "PlatformZone.count", +1 do
        PlatformZoneAdapter.new(@bob, @vcr).fetch
      end
    end
  end
end

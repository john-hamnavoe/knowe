# frozen_string_literal: true

require "test_helper"

class PlatformBusinessTypeAdapterTest < ActionDispatch::IntegrationTest

  def setup
    @bob = users(:bob)
    @vcr = projects(:vcr)
  end

  test "fetch" do
    VCR.use_cassette("platform business type fetch") do
      # Perform initial fetch
      assert_difference "PlatformBusinessType.count", +7 do
        PlatformBusinessTypeAdapter.new(@bob, @vcr).fetch
      end

      # Perform second fetch with new item and changed item
      assert_no_difference "PlatformBusinessType.count" do
        PlatformBusinessTypeAdapter.new(@bob, @vcr).fetch
      end
    end
  end
end

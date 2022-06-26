# frozen_string_literal: true

require "test_helper"

class PlatformDayOfWeekAdapterTest < ActionDispatch::IntegrationTest
  def setup
    @bob = users(:bob)
    @vcr = projects(:vcr)
  end

  test "fetch" do
    VCR.use_cassette("platform day of week fetch") do
      # Perform initial fetch
      assert_difference "PlatformDayOfWeek.count", +7 do
        PlatformDayOfWeekAdapter.new(@bob, @vcr).fetch
      end
    end
  end
end

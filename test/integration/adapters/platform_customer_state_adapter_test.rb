# frozen_string_literal: true

require "test_helper"

class PlatformCustomerStateAdapterTest < ActionDispatch::IntegrationTest
  def setup
    @bob = users(:bob)
    @vcr = projects(:vcr)
  end

  test "fetch" do
    VCR.use_cassette("platform customer state fetch") do
      # Perform initial fetch
      assert_difference "PlatformCustomerState.count", +7 do
        PlatformCustomerStateAdapter.new(@bob, @vcr).fetch
      end
    end
  end
end

# frozen_string_literal: true

require "test_helper"

class PlatformCustomerSiteStateAdapterTest < ActionDispatch::IntegrationTest
  def setup
    @bob = users(:bob)
    @vcr = projects(:vcr)
  end

  test "fetch" do
    VCR.use_cassette("platform customer site state fetch") do
      # Perform initial fetch
      assert_difference "PlatformCustomerSiteState.count", +4 do
        PlatformCustomerSiteStateAdapter.new(@bob, @vcr).fetch
      end
    end
  end
end

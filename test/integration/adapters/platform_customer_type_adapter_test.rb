# frozen_string_literal: true

require "test_helper"

class PlatformCustomerTypeAdapterTest < ActionDispatch::IntegrationTest
  def setup
    @bob = users(:bob)
    @vcr = projects(:vcr)
  end

  test "fetch" do
    VCR.use_cassette("platform customer type fetch") do
      # Perform initial fetch
      assert_difference "PlatformCustomerType.count", +3 do
        PlatformCustomerTypeAdapter.new(@bob, @vcr).fetch
      end
    end
  end
end

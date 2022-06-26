# frozen_string_literal: true

require "test_helper"

class PlatformPriorityAdapterTest < ActionDispatch::IntegrationTest

  def setup
    @bob = users(:bob)
    @vcr = projects(:vcr)
  end

  test "fetch" do
    VCR.use_cassette("platform priority fetch") do
      # Perform initial fetch
      assert_difference "PlatformPriority.count", +1 do
        PlatformPriorityAdapter.new(@bob, @vcr).fetch
      end
    end
  end
end

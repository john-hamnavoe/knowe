# frozen_string_literal: true

require "test_helper"

class PlatformSicCodeAdapterTest < ActionDispatch::IntegrationTest

  def setup
    @bob = users(:bob)
    @vcr = projects(:vcr)
  end

  test "fetch" do
    VCR.use_cassette("platform sic code fetch") do
      # Perform initial fetch
      assert_difference "PlatformSicCode.count", +1306 do
        PlatformSicCodeAdapter.new(@bob, @vcr).fetch
      end
    end
  end
end

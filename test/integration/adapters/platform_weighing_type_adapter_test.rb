# frozen_string_literal: true

require "test_helper"

class PlatformWeighingTypeAdapterTest < ActionDispatch::IntegrationTest

  def setup
    @bob = users(:bob)
    @vcr = projects(:vcr)
  end

  test "fetch" do
    VCR.use_cassette("platform weighing type fetch") do
      # Perform initial fetch
      assert_difference "PlatformWeighingType.count", +7 do
        PlatformWeighingTypeAdapter.new(@bob, @vcr).fetch
      end
    end
  end
end


# frozen_string_literal: true

require "test_helper"

class PlatformContactTypeAdapterTest < ActionDispatch::IntegrationTest

  def setup
    @bob = users(:bob)
    @vcr = projects(:vcr)
  end

  test "fetch" do
    VCR.use_cassette("platform contact type fetch") do
      # Perform initial fetch
      assert_difference "PlatformContactType.count", +3 do
        PlatformContactTypeAdapter.new(@bob, @vcr).fetch
      end
      assert PlatformContactType.where(project: @vcr, description: "Financial Contact").count == 1

      # Perform second fetch with new item and changed item
      assert_difference "PlatformContactType.count", +1 do
        PlatformContactTypeAdapter.new(@bob, @vcr).fetch
      end
      assert PlatformContactType.where(project: @vcr, description: "Financial Contact").count.zero?
      assert PlatformContactType.where(project: @vcr, description: "Fin Contact").count == 1
    end
  end
end
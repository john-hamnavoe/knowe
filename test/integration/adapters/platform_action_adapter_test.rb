# frozen_string_literal: true

require "test_helper"

class PlatformActionAdapterTest < ActionDispatch::IntegrationTest

  def setup
    @bob = users(:bob)
    @vcr = projects(:vcr)
  end

  test "fetch" do
    VCR.use_cassette("platform action fetch") do
      # Perform initial fetch
      assert_difference "PlatformAction.count", +6 do
        PlatformActionAdapter.new(@bob, @vcr).fetch
      end
      assert PlatformAction.where(project: @vcr, description: "Drop").count == 1

      # Perform second fetch with new item and changed item
      assert_difference "PlatformAction.count", +1 do
        PlatformActionAdapter.new(@bob, @vcr).fetch
      end
      assert PlatformAction.where(project: @vcr, description: "Drop").count.zero?
      assert PlatformAction.where(project: @vcr, description: "Drop Drop").count == 1
    end
  end
end

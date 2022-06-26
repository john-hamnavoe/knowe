# frozen_string_literal: true

require "test_helper"

class PlatformContainerTypeAdapterTest < ActionDispatch::IntegrationTest
  def setup
    @bob = users(:bob)
    @vcr = projects(:vcr)
  end

  test "fetch" do
    VCR.use_cassette("platform container type fetch") do
      # Perform initial fetch
      assert_difference "PlatformContainerType.count", +5 do
        PlatformContainerTypeAdapter.new(@bob, @vcr).fetch
      end
      assert PlatformContainerType.where(project: @vcr, is_deleted: true).count.zero?

      # Perform second fetch with new item and changed item
      assert_difference "PlatformContainerType.count", +1 do
        PlatformContainerTypeAdapter.new(@bob, @vcr).fetch
      end
      assert PlatformContainerType.where(project: @vcr, is_deleted: true).count == 1
    end
  end
end

# frozen_string_literal: true

require "test_helper"

class PlatformServiceAdapterTest < ActionDispatch::IntegrationTest

  def setup
    @bob = users(:bob)
    @vcr = projects(:vcr)
  end

  test "fetch" do
    VCR.use_cassette("platform service fetch") do
      # Perform initial fetch
      assert_difference "PlatformService.count", +26 do
        PlatformServiceAdapter.new(@bob, @vcr).fetch
      end
      assert PlatformService.where(project: @vcr, is_deleted: true).count == 13, PlatformService.where(project: @vcr, is_deleted: true).count

      # Perform second fetch with new item and changed item
      assert_difference "PlatformService.count", +1 do
        PlatformServiceAdapter.new(@bob, @vcr).fetch
      end
      assert PlatformService.where(project: @vcr, is_deleted: true).count == 12
    end
  end
end

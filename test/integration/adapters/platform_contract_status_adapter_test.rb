# frozen_string_literal: true

require "test_helper"

class PlatformContractStatusAdapterTest < ActionDispatch::IntegrationTest
  def setup
    @bob = users(:bob)
    @vcr = projects(:vcr)
  end

  test "fetch" do
    VCR.use_cassette("platform contract status fetch") do
      # Perform initial fetch
      assert_difference "PlatformContractStatus.count", +3 do
        PlatformContractStatusAdapter.new(@bob, @vcr).fetch
      end
      assert PlatformContractStatus.where(project: @vcr, is_deleted: true).count.zero?

      # Perform second fetch with new item and changed item
      assert_difference "PlatformContractStatus.count", +1 do
        PlatformContractStatusAdapter.new(@bob, @vcr).fetch
      end
      assert PlatformContractStatus.where(project: @vcr, is_deleted: true).count == 1
    end
  end
end
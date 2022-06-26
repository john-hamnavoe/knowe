# frozen_string_literal: true

require "test_helper"

class PlatformCurrencyAdapterTest < ActionDispatch::IntegrationTest
  def setup
    @bob = users(:bob)
    @vcr = projects(:vcr)
  end

  test "fetch" do
    VCR.use_cassette("platform currency fetch") do
      # Perform initial fetch
      assert_difference "PlatformCurrency.count", +3 do
        PlatformCurrencyAdapter.new(@bob, @vcr).fetch
      end
      assert PlatformCurrency.where(project: @vcr, is_deleted: true).count == 2

      # Perform second fetch with new item and changed item
      assert_difference "PlatformCurrency.count", +1 do
        PlatformCurrencyAdapter.new(@bob, @vcr).fetch
      end
      assert PlatformCurrency.where(project: @vcr, is_deleted: true).count == 1
    end
  end
end


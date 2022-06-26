# frozen_string_literal: true

require "test_helper"

class PlatformInvoiceCycleAdapterTest < ActionDispatch::IntegrationTest

  def setup
    @bob = users(:bob)
    @vcr = projects(:vcr)
  end

  test "fetch" do
    VCR.use_cassette("platform invoice cycle fetch") do
      # Perform initial fetch
      assert_difference "PlatformInvoiceCycle.count", +4 do
        PlatformInvoiceCycleAdapter.new(@bob, @vcr).fetch
      end
      assert PlatformInvoiceCycle.where(project: @vcr, is_deleted: true).count == 2

      # Perform second fetch with new item and changed item
      assert_difference "PlatformInvoiceCycle.count", +1 do
        PlatformInvoiceCycleAdapter.new(@bob, @vcr).fetch
      end
      assert PlatformInvoiceCycle.where(project: @vcr, is_deleted: true).count.zero?
    end
  end
end


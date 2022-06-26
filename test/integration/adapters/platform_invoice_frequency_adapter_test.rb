# frozen_string_literal: true

require "test_helper"

class PlatformInvoiceFrequencyAdapterTest < ActionDispatch::IntegrationTest

  def setup
    @bob = users(:bob)
    @vcr = projects(:vcr)
  end

  test "fetch" do
    VCR.use_cassette("platform invoice frequency fetch") do
      # Perform initial fetch
      assert_difference "PlatformInvoiceFrequency.count", +6 do
        PlatformInvoiceFrequencyAdapter.new(@bob, @vcr).fetch
      end
      assert PlatformInvoiceFrequency.where(project: @vcr, is_deleted: true).count == 1

      # Perform second fetch with new item and changed item
      assert_difference "PlatformInvoiceFrequency.count", +1 do
        PlatformInvoiceFrequencyAdapter.new(@bob, @vcr).fetch
      end
      assert PlatformInvoiceFrequency.where(project: @vcr, is_deleted: true).count.zero?
    end
  end
end

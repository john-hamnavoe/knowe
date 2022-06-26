# frozen_string_literal: true

require "test_helper"

class PlatformPaymentTermAdapterTest < ActionDispatch::IntegrationTest

  def setup
    @bob = users(:bob)
    @vcr = projects(:vcr)
  end

  test "fetch" do
    VCR.use_cassette("platform payment term fetch") do
      # Perform initial fetch
      assert_difference "PlatformPaymentTerm.count", +12 do
        PlatformPaymentTermAdapter.new(@bob, @vcr).fetch
      end
      assert PlatformPaymentTerm.where(project: @vcr, is_deleted: true).count == 5, PlatformPaymentTerm.where(project: @vcr, is_deleted: true).count

      # Perform second fetch with new item and changed item
      assert_difference "PlatformPaymentTerm.count", +2 do
        PlatformPaymentTermAdapter.new(@bob, @vcr).fetch
      end
      assert PlatformPaymentTerm.where(project: @vcr, is_deleted: true).count.zero?
    end
  end
end

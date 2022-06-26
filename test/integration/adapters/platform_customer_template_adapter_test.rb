# frozen_string_literal: true

require "test_helper"

class PlatformCustomerTemplateAdapterTest < ActionDispatch::IntegrationTest

  def setup
    @bob = users(:bob)
    @vcr = projects(:vcr)
  end

  test "fetch" do
    VCR.use_cassette("platform customer template fetch") do
      # Perform initial fetch
      assert_difference "PlatformCustomerTemplate.count", +3 do
        PlatformCustomerTemplateAdapter.new(@bob, @vcr).fetch
      end
      assert PlatformCustomerTemplate.where(project: @vcr, is_deleted: true).count == 1

      # Perform second fetch with new item and changed item
      assert_difference "PlatformCustomerTemplate.count", +1 do
        PlatformCustomerTemplateAdapter.new(@bob, @vcr).fetch
      end
      assert PlatformCustomerTemplate.where(project: @vcr, is_deleted: true).count.zero?
    end
  end
end

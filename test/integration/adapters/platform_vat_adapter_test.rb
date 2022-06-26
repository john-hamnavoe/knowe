# frozen_string_literal: true

require "test_helper"

class PlatformVatAdapterTest < ActionDispatch::IntegrationTest

  def setup
    @bob = users(:bob)
    @vcr = projects(:vcr)
  end

  test "fetch" do
    VCR.use_cassette("platform vat fetch") do
      # Perform initial fetch
      assert_difference "PlatformVat.count", +3 do
        PlatformVatAdapter.new(@bob, @vcr).fetch
      end
    end
  end
end
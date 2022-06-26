# frozen_string_literal: true

require "test_helper"

class PlatformMaterialAdapterTest < ActionDispatch::IntegrationTest

  def setup
    @bob = users(:bob)
    @vcr = projects(:vcr)
  end

  test "fetch" do
    VCR.use_cassette("platform material fetch") do
      # Perform initial fetch
      assert_difference "PlatformMaterial.count", +39 do
         PlatformMaterialAdapter.new(@bob, @vcr).fetch
      end
    end
  end
end

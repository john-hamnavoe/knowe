# frozen_string_literal: true

require "test_helper"

class PlatformExternalVehicleAdapterTest < ActionDispatch::IntegrationTest

  def setup
    @bob = users(:bob)
    @vcr = projects(:vcr)
  end

  test "fetch" do
    VCR.use_cassette("platform external vehicle fetch") do
      # NOTE: This test is doing nothing as no external vebicles set up yet
      assert_no_difference "PlatformExternalVehicle.count" do
        PlatformExternalVehicleAdapter.new(@bob, @vcr).fetch
      end

      # Perform second fetch with new item and changed item
      assert_no_difference "PlatformExternalVehicle.count" do
         PlatformExternalVehicleAdapter.new(@bob, @vcr).fetch
      end
    end
  end
end


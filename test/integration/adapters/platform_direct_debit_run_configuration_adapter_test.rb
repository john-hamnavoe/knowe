# frozen_string_literal: true

require "test_helper"

class PlatformDirectDebitRunConfigurationAdapterTest < ActionDispatch::IntegrationTest

  def setup
    @bob = users(:bob)
    @vcr = projects(:vcr)
  end

  test "fetch" do
    VCR.use_cassette("platform direct debit run configuration fetch") do
      # Perform initial fetch
      assert_difference "PlatformDirectDebitRunConfiguration.count", +1 do
        PlatformDirectDebitRunConfigurationAdapter.new(@bob, @vcr).fetch
      end

      # Perform second fetch with new item and changed item
      assert_no_difference "PlatformDirectDebitRunConfiguration.count" do
        PlatformDirectDebitRunConfigurationAdapter.new(@bob, @vcr).fetch
      end
    end
  end
end

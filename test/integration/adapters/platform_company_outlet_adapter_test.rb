# frozen_string_literal: true

require "test_helper"

class PlatformCompanyOutletAdapterTest < ActionDispatch::IntegrationTest 

  def setup
    @bob = users(:bob)
    @vcr = projects(:vcr)
  end

  test "fetch" do
    VCR.use_cassette("platform company outlet fetch") do
      # Perform initial fetch
      assert_difference "PlatformCompany.count", +1 do
        assert_difference "PlatformCompanyOutlet.count", +3 do
          PlatformCompanyOutletAdapter.new(@bob, @vcr).fetch
        end
      end

      # Perform second fetch with new item and changed item
      assert_no_difference "PlatformCompany.count" do
        assert_no_difference "PlatformCompanyOutlet.count" do
          PlatformCompanyOutletAdapter.new(@bob, @vcr).fetch
        end
      end
    end
  end
end

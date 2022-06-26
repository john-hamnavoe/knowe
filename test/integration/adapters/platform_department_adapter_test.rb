# frozen_string_literal: true

require "test_helper"

class PlatformDepartmentAdapterTest < ActionDispatch::IntegrationTest

  def setup
    @bob = users(:bob)
    @vcr = projects(:vcr)
  end

  test "fetch" do
    VCR.use_cassette("platform department fetch") do
      # Perform initial fetch
      assert_difference "PlatformDepartment.count", +2 do
        PlatformDepartmentAdapter.new(@bob, @vcr).fetch
      end
      assert PlatformDepartment.where(project: @vcr, is_deleted: true).count == 1

      # Perform second fetch with new item and changed item
      assert_difference "PlatformDepartment.count", +1 do
        PlatformDepartmentAdapter.new(@bob, @vcr).fetch
      end
      assert PlatformDepartment.where(project: @vcr, is_deleted: true).count.zero?
    end
  end
end

require "test_helper"

class ProjectTest < ActiveSupport::TestCase
  def setup
    @project = Project.new(name: "new", user: users(:bob))
  end

  test "the validation" do
    assert @project.valid?
  end

  test "name validation" do
    @project.name = "a" * 51
    assert_not @project.valid?
  end

  test "user validation" do
    @project.user = nil
    assert_not @project.valid?
  end
end

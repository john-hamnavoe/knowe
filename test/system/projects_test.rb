require "application_system_test_case"

class ProjectsTest < ApplicationSystemTestCase
  setup do
    @project = projects(:one)
  end

  test "visiting the index" do
    visit projects_url
    assert_selector "h1", text: "Projects"
  end

  test "should create project" do
    visit projects_url
    click_on "New project"

    check "Active" if @project.active
    fill_in "Auth cookie", with: @project.auth_cookie
    fill_in "Auth cookie updated at", with: @project.auth_cookie_updated_at
    fill_in "Base url", with: @project.base_url
    fill_in "Expiry minutes", with: @project.expiry_minutes
    fill_in "Name", with: @project.name
    fill_in "Pat token", with: @project.pat_token
    fill_in "User", with: @project.user_id
    fill_in "Version", with: @project.version
    click_on "Create Project"

    assert_text "Project was successfully created"
    click_on "Back"
  end

  test "should update Project" do
    visit project_url(@project)
    click_on "Edit this project", match: :first

    check "Active" if @project.active
    fill_in "Auth cookie", with: @project.auth_cookie
    fill_in "Auth cookie updated at", with: @project.auth_cookie_updated_at
    fill_in "Base url", with: @project.base_url
    fill_in "Expiry minutes", with: @project.expiry_minutes
    fill_in "Name", with: @project.name
    fill_in "Pat token", with: @project.pat_token
    fill_in "User", with: @project.user_id
    fill_in "Version", with: @project.version
    click_on "Update Project"

    assert_text "Project was successfully updated"
    click_on "Back"
  end

  test "should destroy Project" do
    visit project_url(@project)
    click_on "Destroy this project", match: :first

    assert_text "Project was successfully destroyed"
  end
end

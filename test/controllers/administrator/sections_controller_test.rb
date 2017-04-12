require 'test_helper'

class Administrator::SectionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @administrator_section = administrator_sections(:one)
  end

  test "should get index" do
    get administrator_sections_url
    assert_response :success
  end

  test "should get new" do
    get new_administrator_section_url
    assert_response :success
  end

  test "should create administrator_section" do
    assert_difference('Administrator::Section.count') do
      post administrator_sections_url, params: { administrator_section: { name: @administrator_section.name } }
    end

    assert_redirected_to administrator_section_url(Administrator::Section.last)
  end

  test "should show administrator_section" do
    get administrator_section_url(@administrator_section)
    assert_response :success
  end

  test "should get edit" do
    get edit_administrator_section_url(@administrator_section)
    assert_response :success
  end

  test "should update administrator_section" do
    patch administrator_section_url(@administrator_section), params: { administrator_section: { name: @administrator_section.name } }
    assert_redirected_to administrator_section_url(@administrator_section)
  end

  test "should destroy administrator_section" do
    assert_difference('Administrator::Section.count', -1) do
      delete administrator_section_url(@administrator_section)
    end

    assert_redirected_to administrator_sections_url
  end
end

require 'test_helper'

class Admin::InstitutionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin_institution = admin_institutions(:one)
  end

  test "should get index" do
    get admin_institutions_url
    assert_response :success
  end

  test "should get new" do
    get new_admin_institution_url
    assert_response :success
  end

  test "should create admin_institution" do
    assert_difference('Admin::Institution.count') do
      post admin_institutions_url, params: { admin_institution: { city: @admin_institution.city, country: @admin_institution.country, description: @admin_institution.description, latitude: @admin_institution.latitude, level: @admin_institution.level, location: @admin_institution.location, longitude: @admin_institution.longitude, name: @admin_institution.name, sector: @admin_institution.sector } }
    end

    assert_redirected_to admin_institution_url(Admin::Institution.last)
  end

  test "should show admin_institution" do
    get admin_institution_url(@admin_institution)
    assert_response :success
  end

  test "should get edit" do
    get edit_admin_institution_url(@admin_institution)
    assert_response :success
  end

  test "should update admin_institution" do
    patch admin_institution_url(@admin_institution), params: { admin_institution: { city: @admin_institution.city, country: @admin_institution.country, description: @admin_institution.description, latitude: @admin_institution.latitude, level: @admin_institution.level, location: @admin_institution.location, longitude: @admin_institution.longitude, name: @admin_institution.name, sector: @admin_institution.sector } }
    assert_redirected_to admin_institution_url(@admin_institution)
  end

  test "should destroy admin_institution" do
    assert_difference('Admin::Institution.count', -1) do
      delete admin_institution_url(@admin_institution)
    end

    assert_redirected_to admin_institutions_url
  end
end

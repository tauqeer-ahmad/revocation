require 'test_helper'

class Admin::AdministratorsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin_administrator = admin_administrators(:one)
  end

  test "should get index" do
    get admin_administrators_url
    assert_response :success
  end

  test "should get new" do
    get new_admin_administrator_url
    assert_response :success
  end

  test "should create admin_administrator" do
    assert_difference('Admin::Administrator.count') do
      post admin_administrators_url, params: { admin_administrator: { email: @admin_administrator.email, name: @admin_administrator.name, password: @admin_administrator.password } }
    end

    assert_redirected_to admin_administrator_url(Admin::Administrator.last)
  end

  test "should show admin_administrator" do
    get admin_administrator_url(@admin_administrator)
    assert_response :success
  end

  test "should get edit" do
    get edit_admin_administrator_url(@admin_administrator)
    assert_response :success
  end

  test "should update admin_administrator" do
    patch admin_administrator_url(@admin_administrator), params: { admin_administrator: { email: @admin_administrator.email, name: @admin_administrator.name, password: @admin_administrator.password } }
    assert_redirected_to admin_administrator_url(@admin_administrator)
  end

  test "should destroy admin_administrator" do
    assert_difference('Admin::Administrator.count', -1) do
      delete admin_administrator_url(@admin_administrator)
    end

    assert_redirected_to admin_administrators_url
  end
end

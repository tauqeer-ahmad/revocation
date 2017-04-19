require 'test_helper'

class Administrator::GuardiansControllerTest < ActionDispatch::IntegrationTest
  setup do
    @administrator_guardian = administrator_guardians(:one)
  end

  test "should get index" do
    get administrator_guardians_url
    assert_response :success
  end

  test "should get new" do
    get new_administrator_guardian_url
    assert_response :success
  end

  test "should create administrator_guardian" do
    assert_difference('Administrator::Guardian.count') do
      post administrator_guardians_url, params: { administrator_guardian: {  } }
    end

    assert_redirected_to administrator_guardian_url(Administrator::Guardian.last)
  end

  test "should show administrator_guardian" do
    get administrator_guardian_url(@administrator_guardian)
    assert_response :success
  end

  test "should get edit" do
    get edit_administrator_guardian_url(@administrator_guardian)
    assert_response :success
  end

  test "should update administrator_guardian" do
    patch administrator_guardian_url(@administrator_guardian), params: { administrator_guardian: {  } }
    assert_redirected_to administrator_guardian_url(@administrator_guardian)
  end

  test "should destroy administrator_guardian" do
    assert_difference('Administrator::Guardian.count', -1) do
      delete administrator_guardian_url(@administrator_guardian)
    end

    assert_redirected_to administrator_guardians_url
  end
end

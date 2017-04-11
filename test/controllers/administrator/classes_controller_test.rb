require 'test_helper'

class Administrator::ClassesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @administrator_class = administrator_classes(:one)
  end

  test "should get index" do
    get administrator_classes_url
    assert_response :success
  end

  test "should get new" do
    get new_administrator_class_url
    assert_response :success
  end

  test "should create administrator_class" do
    assert_difference('Administrator::Class.count') do
      post administrator_classes_url, params: { administrator_class: {  } }
    end

    assert_redirected_to administrator_class_url(Administrator::Class.last)
  end

  test "should show administrator_class" do
    get administrator_class_url(@administrator_class)
    assert_response :success
  end

  test "should get edit" do
    get edit_administrator_class_url(@administrator_class)
    assert_response :success
  end

  test "should update administrator_class" do
    patch administrator_class_url(@administrator_class), params: { administrator_class: {  } }
    assert_redirected_to administrator_class_url(@administrator_class)
  end

  test "should destroy administrator_class" do
    assert_difference('Administrator::Class.count', -1) do
      delete administrator_class_url(@administrator_class)
    end

    assert_redirected_to administrator_classes_url
  end
end

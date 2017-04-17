require 'test_helper'

class Administrator::StudentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @administrator_student = administrator_students(:one)
  end

  test "should get index" do
    get administrator_students_url
    assert_response :success
  end

  test "should get new" do
    get new_administrator_student_url
    assert_response :success
  end

  test "should create administrator_student" do
    assert_difference('Administrator::Student.count') do
      post administrator_students_url, params: { administrator_student: {  } }
    end

    assert_redirected_to administrator_student_url(Administrator::Student.last)
  end

  test "should show administrator_student" do
    get administrator_student_url(@administrator_student)
    assert_response :success
  end

  test "should get edit" do
    get edit_administrator_student_url(@administrator_student)
    assert_response :success
  end

  test "should update administrator_student" do
    patch administrator_student_url(@administrator_student), params: { administrator_student: {  } }
    assert_redirected_to administrator_student_url(@administrator_student)
  end

  test "should destroy administrator_student" do
    assert_difference('Administrator::Student.count', -1) do
      delete administrator_student_url(@administrator_student)
    end

    assert_redirected_to administrator_students_url
  end
end

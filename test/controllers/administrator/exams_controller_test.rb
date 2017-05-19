require 'test_helper'

class Administrator::ExamsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @administrator_exam = administrator_exams(:one)
  end

  test "should get index" do
    get administrator_exams_url
    assert_response :success
  end

  test "should get new" do
    get new_administrator_exam_url
    assert_response :success
  end

  test "should create administrator_exam" do
    assert_difference('Administrator::Exam.count') do
      post administrator_exams_url, params: { administrator_exam: { comment: @administrator_exam.comment, name: @administrator_exam.name, start_date: @administrator_exam.start_date } }
    end

    assert_redirected_to administrator_exam_url(Administrator::Exam.last)
  end

  test "should show administrator_exam" do
    get administrator_exam_url(@administrator_exam)
    assert_response :success
  end

  test "should get edit" do
    get edit_administrator_exam_url(@administrator_exam)
    assert_response :success
  end

  test "should update administrator_exam" do
    patch administrator_exam_url(@administrator_exam), params: { administrator_exam: { comment: @administrator_exam.comment, name: @administrator_exam.name, start_date: @administrator_exam.start_date } }
    assert_redirected_to administrator_exam_url(@administrator_exam)
  end

  test "should destroy administrator_exam" do
    assert_difference('Administrator::Exam.count', -1) do
      delete administrator_exam_url(@administrator_exam)
    end

    assert_redirected_to administrator_exams_url
  end
end

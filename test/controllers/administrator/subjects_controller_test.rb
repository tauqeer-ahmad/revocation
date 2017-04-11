require 'test_helper'

class Administrator::SubjectsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @administrator_subject = administrator_subjects(:one)
  end

  test "should get index" do
    get administrator_subjects_url
    assert_response :success
  end

  test "should get new" do
    get new_administrator_subject_url
    assert_response :success
  end

  test "should create administrator_subject" do
    assert_difference('Administrator::Subject.count') do
      post administrator_subjects_url, params: { administrator_subject: { description: @administrator_subject.description, name: @administrator_subject.name } }
    end

    assert_redirected_to administrator_subject_url(Administrator::Subject.last)
  end

  test "should show administrator_subject" do
    get administrator_subject_url(@administrator_subject)
    assert_response :success
  end

  test "should get edit" do
    get edit_administrator_subject_url(@administrator_subject)
    assert_response :success
  end

  test "should update administrator_subject" do
    patch administrator_subject_url(@administrator_subject), params: { administrator_subject: { description: @administrator_subject.description, name: @administrator_subject.name } }
    assert_redirected_to administrator_subject_url(@administrator_subject)
  end

  test "should destroy administrator_subject" do
    assert_difference('Administrator::Subject.count', -1) do
      delete administrator_subject_url(@administrator_subject)
    end

    assert_redirected_to administrator_subjects_url
  end
end

require 'test_helper'

class Administrator::TimetablesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @administrator_timetable = administrator_timetables(:one)
  end

  test "should get index" do
    get administrator_timetables_url
    assert_response :success
  end

  test "should get new" do
    get new_administrator_timetable_url
    assert_response :success
  end

  test "should create administrator_timetable" do
    assert_difference('Administrator::Timetable.count') do
      post administrator_timetables_url, params: { administrator_timetable: { end_time: @administrator_timetable.end_time, start_time: @administrator_timetable.start_time } }
    end

    assert_redirected_to administrator_timetable_url(Administrator::Timetable.last)
  end

  test "should show administrator_timetable" do
    get administrator_timetable_url(@administrator_timetable)
    assert_response :success
  end

  test "should get edit" do
    get edit_administrator_timetable_url(@administrator_timetable)
    assert_response :success
  end

  test "should update administrator_timetable" do
    patch administrator_timetable_url(@administrator_timetable), params: { administrator_timetable: { end_time: @administrator_timetable.end_time, start_time: @administrator_timetable.start_time } }
    assert_redirected_to administrator_timetable_url(@administrator_timetable)
  end

  test "should destroy administrator_timetable" do
    assert_difference('Administrator::Timetable.count', -1) do
      delete administrator_timetable_url(@administrator_timetable)
    end

    assert_redirected_to administrator_timetables_url
  end
end

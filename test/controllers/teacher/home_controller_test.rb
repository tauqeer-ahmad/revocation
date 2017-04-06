require 'test_helper'

class Teacher::HomeControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get teacher_home_index_url
    assert_response :success
  end

end

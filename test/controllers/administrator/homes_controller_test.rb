require 'test_helper'

class Administrator::HomesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get administrator_homes_index_url
    assert_response :success
  end

end

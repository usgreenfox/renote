require 'test_helper'

class RecommendsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get recommends_index_url
    assert_response :success
  end

end

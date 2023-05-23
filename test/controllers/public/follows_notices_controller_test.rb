require "test_helper"

class Public::FollowsNoticesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get public_follows_notices_index_url
    assert_response :success
  end
end

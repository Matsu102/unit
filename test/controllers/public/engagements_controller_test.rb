require "test_helper"

class Public::EngagementsControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get public_engagements_show_url
    assert_response :success
  end
end

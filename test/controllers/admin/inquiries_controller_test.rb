require "test_helper"

class Admin::InquiriesControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get admin_inquiries_show_url
    assert_response :success
  end
end

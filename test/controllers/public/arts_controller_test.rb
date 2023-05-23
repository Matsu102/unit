require "test_helper"

class Public::ArtsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get public_arts_index_url
    assert_response :success
  end

  test "should get new" do
    get public_arts_new_url
    assert_response :success
  end

  test "should get show" do
    get public_arts_show_url
    assert_response :success
  end

  test "should get edit" do
    get public_arts_edit_url
    assert_response :success
  end

  test "should get my_album" do
    get public_arts_my_album_url
    assert_response :success
  end
end

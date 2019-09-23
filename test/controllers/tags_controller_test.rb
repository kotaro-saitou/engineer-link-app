require 'test_helper'

class TagsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get tags_index_url
    assert_response :success
  end

  test "should get show" do
    get tags_show_url
    assert_response :success
  end

  test "should get create" do
    get tags_create_url
    assert_response :success
  end

  test "should get destroy" do
    get tags_destroy_url
    assert_response :success
  end

end

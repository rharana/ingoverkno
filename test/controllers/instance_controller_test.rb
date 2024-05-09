require "test_helper"

class InstanceControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get instance_new_url
    assert_response :success
  end

  test "should get create" do
    get instance_create_url
    assert_response :success
  end

  test "should get update" do
    get instance_update_url
    assert_response :success
  end

  test "should get delete" do
    get instance_delete_url
    assert_response :success
  end

  test "should get read" do
    get instance_read_url
    assert_response :success
  end

  test "should get list" do
    get instance_list_url
    assert_response :success
  end
end

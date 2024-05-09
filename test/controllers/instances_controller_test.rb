require "test_helper"

class InstancesControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get instances_new_url
    assert_response :success
  end

  test "should get create" do
    get instances_create_url
    assert_response :success
  end

  test "should get update" do
    get instances_update_url
    assert_response :success
  end

  test "should get delete" do
    get instances_delete_url
    assert_response :success
  end

  test "should get read" do
    get instances_read_url
    assert_response :success
  end

  test "should get list" do
    get instances_list_url
    assert_response :success
  end
end

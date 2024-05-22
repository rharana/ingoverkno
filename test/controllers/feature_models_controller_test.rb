require "test_helper"

class FeatureModelsControllerTest < ActionDispatch::IntegrationTest
  test "should get list" do
    get feature_models_list_url
    assert_response :success
  end
end

class FeatureModelsController < ApplicationController

  def index
    @feature_models = FeatureModel.all
    @true_features_list = @feature_models.map { |model| true_features(model) }
  end

  private

  def true_features(feature_model)
    # Selecting only attributes that are true
    feature_model.attributes.filter { |key, value| value == true }
  end


end


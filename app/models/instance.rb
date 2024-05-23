class Instance < ApplicationRecord
    has_one_attached :banner
    has_one_attached :logo
    has_one :feature_model
    accepts_nested_attributes_for :feature_model
    enum status: { shut: 0, pending: 1, running: 2 }
end
class Instance < ApplicationRecord
    validates :name, presence: { message: 'should only include letters, numbers, and underscores' }
    has_one :feature_model
    accepts_nested_attributes_for :feature_model
    enum status: { shut: 0, pending: 1, running: 2 }
end

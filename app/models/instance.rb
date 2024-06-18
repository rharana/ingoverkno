class Instance < ApplicationRecord
    validates :name, presence: { message: 'Field is mandatory' }
    validates :name, no_special_chars: true
    validates :name, uniqueness: { message: 'Already in use' }
    validates :port, presence: { message: 'Field is mandatory' }
    validates :shakapacker_port, presence: { message: 'Field is mandatory' }
    validates :population, presence: { message: 'Field is mandatory' }
    validates :province, presence: { message: 'Field is mandatory' }
    has_one :feature_model
    accepts_nested_attributes_for :feature_model
    enum status: { shut: 0, pending: 1, running: 2 }
end

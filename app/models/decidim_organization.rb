class DecidimOrganization < ApplicationRecord
    # Validations
    validates :name, :host, :default_locale, :reference_prefix, presence: true
    validates :host, :name, uniqueness: true
  
    # Serialization for Array columns since Rails does not natively handle Postgres arrays
end

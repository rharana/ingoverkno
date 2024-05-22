class Instance < ApplicationRecord
    has_one_attached :banner
    has_one_attached :logo
end

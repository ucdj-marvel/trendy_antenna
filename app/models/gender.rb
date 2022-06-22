class Gender < ApplicationRecord
  has_many :outfit_posters, dependent: :nullify
end

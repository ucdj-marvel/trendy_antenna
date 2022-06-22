class RankingType < ApplicationRecord
  has_many :outfit_posters, dependent: :delete_all
end

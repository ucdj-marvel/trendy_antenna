class RankingType < ApplicationRecord
  has_many :outfit_rankings, dependent: :delete_all
end

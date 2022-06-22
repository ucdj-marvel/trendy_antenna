class OutfitRanking < ApplicationRecord
  belongs_to :outfit_detail
  belongs_to :ranking_type
end

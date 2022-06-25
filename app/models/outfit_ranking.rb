class OutfitRanking < ApplicationRecord
  belongs_to :outfit_detail
  belongs_to :ranking_type

  scope :with_outfit_detail_and_poster, -> {
    joins(outfit_detail: :outfit_poster)
  }
  scope :with_ranking_type, -> {
    joins(:ranking_type)
  }
end

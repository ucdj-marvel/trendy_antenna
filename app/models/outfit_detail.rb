class OutfitDetail < ApplicationRecord
  has_many :outfit_rankings, dependent: :delete_all
  belongs_to :outfit_poster
end

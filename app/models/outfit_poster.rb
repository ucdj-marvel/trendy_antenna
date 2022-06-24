class OutfitPoster < ApplicationRecord
  has_many :outfit_details, dependent: :delete_all
  belongs_to :gender
  belongs_to :hairstyle, optional: true
end

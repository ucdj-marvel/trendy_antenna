class AcquisitionResult < ApplicationRecord
  enum :command, {
    wear: 0
  }
  validates :command, uniqueness: { scope: :date }
end

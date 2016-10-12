class List < ApplicationRecord
  # Goals
  
  has_many :cards
  belongs_to :board
end

class Feature < ApplicationRecord
  TYPES = %w[Passive Action Reaction].freeze

  belongs_to :adversary, inverse_of: :features

  validates :name, presence: true
  validates :feature_type, presence: true, inclusion: { in: TYPES }
  validates :description, presence: true
end

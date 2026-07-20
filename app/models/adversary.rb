class Adversary < ApplicationRecord
  TYPES = %w[Bruiser Horde Leader Minion Ranged Skulk Social Solo Standard Support].freeze
  RANGES = ["Melee", "Very Close", "Close", "Far", "Very Far"].freeze

  has_many :features, -> { order(:position) }, dependent: :destroy, inverse_of: :adversary
  accepts_nested_attributes_for :features, allow_destroy: true, reject_if: :all_blank

  validates :name, presence: true
  validates :tier, presence: true, inclusion: { in: 1..4 }
  validates :adversary_type, presence: true, inclusion: { in: TYPES }
  validates :difficulty, presence: true, numericality: { only_integer: true }
  validates :hp, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :stress, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :atk, presence: true, numericality: { only_integer: true }
  validates :attack_name, presence: true
  validates :attack_range, presence: true, inclusion: { in: RANGES }
  validates :attack_damage, presence: true
  validates :threshold_major, numericality: { only_integer: true }, allow_nil: true
  validates :threshold_severe, numericality: { only_integer: true }, allow_nil: true
  validates :attack_type, inclusion: { in: %w[phy mag] }, allow_blank: true

  def dup_with_features
    copy = dup
    copy.template = false
    copy.features = features.map(&:dup)
    copy
  end
end

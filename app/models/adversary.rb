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
  validates :attack_type, inclusion: { in: %w[phy mag phy_mag] }, allow_blank: true
  validate :experiences_must_have_positive_values

  def dup_with_features
    copy = dup
    copy.template = false
    copy.features = features.map(&:dup)
    copy
  end

  BUILDER_ATTRIBUTES = %w[
    id name tier adversary_type type_suffix description motives_tactics difficulty
    threshold_major threshold_severe hp stress atk attack_name attack_range
    attack_damage attack_type experiences
  ].freeze

  def to_builder_json
    attributes.slice(*BUILDER_ATTRIBUTES).merge(
      "features" => features.map { |f| { id: f.id, name: f.name, feature_type: f.feature_type, description: f.description, _destroy: false } }
    ).to_json
  end

  def self.templates_json
    where(template: true).order(:tier, :name).map do |a|
      a.attributes.slice(*BUILDER_ATTRIBUTES).except("id").merge(
        "features" => a.features.map { |f| { name: f.name, feature_type: f.feature_type, description: f.description, _destroy: false } }
      )
    end.to_json
  end

  private

  def experiences_must_have_positive_values
    Array(experiences).each do |entry|
      name = entry["name"].presence || entry[:name].presence
      next if name.blank?

      value = entry["value"] || entry[:value]
      next if value.is_a?(Integer) && value >= 1

      errors.add(:base, :experience_value_invalid, name: name)
    end
  end
end

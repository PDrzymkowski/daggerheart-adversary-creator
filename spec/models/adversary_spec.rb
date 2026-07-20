require "rails_helper"

RSpec.describe Adversary, type: :model do
  def valid_attrs(overrides = {})
    {
      name: "Test Adversary",
      tier: 1,
      adversary_type: "Bruiser",
      difficulty: 10,
      hp: 5,
      stress: 3,
      atk: 1,
      attack_name: "Claws",
      attack_range: "Melee",
      attack_damage: "1d6+1"
    }.merge(overrides)
  end

  it "is valid with all required attributes" do
    expect(Adversary.new(valid_attrs)).to be_valid
  end

  it "requires a name" do
    expect(Adversary.new(valid_attrs(name: nil))).not_to be_valid
  end

  it "requires tier to be between 1 and 4" do
    expect(Adversary.new(valid_attrs(tier: 5))).not_to be_valid
    expect(Adversary.new(valid_attrs(tier: 1))).to be_valid
  end

  it "requires adversary_type to be one of the official types" do
    expect(Adversary.new(valid_attrs(adversary_type: "Wizard"))).not_to be_valid
    expect(Adversary::TYPES).to include("Leader", "Horde", "Minion", "Skulk", "Bruiser")
  end

  it "requires attack_range to be one of the official ranges" do
    expect(Adversary.new(valid_attrs(attack_range: "Nowhere"))).not_to be_valid
    expect(Adversary::RANGES).to eq(["Melee", "Very Close", "Close", "Far", "Very Far"])
  end

  it "allows a negative atk" do
    expect(Adversary.new(valid_attrs(atk: -4))).to be_valid
  end

  it "allows thresholds to be blank (Minions have none)" do
    expect(Adversary.new(valid_attrs(threshold_major: nil, threshold_severe: nil))).to be_valid
  end

  describe "#dup_with_features" do
    it "duplicates the adversary with unsaved copies of its features" do
      original = Adversary.create!(valid_attrs(template: true))
      original.features.create!(name: "Bite", feature_type: "Action", description: "Chomp.", position: 0)

      copy = original.dup_with_features

      expect(copy).not_to be_persisted
      expect(copy.template).to eq(false)
      expect(copy.features.size).to eq(1)
      expect(copy.features.first).not_to be_persisted
      expect(copy.features.first.name).to eq("Bite")
    end
  end
end

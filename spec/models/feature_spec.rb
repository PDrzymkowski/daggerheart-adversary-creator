require "rails_helper"

RSpec.describe Feature, type: :model do
  let(:adversary) do
    Adversary.create!(
      name: "Test Adversary", tier: 1, adversary_type: "Bruiser", difficulty: 10,
      hp: 5, stress: 3, atk: 1, attack_name: "Claws", attack_range: "Melee",
      attack_damage: "1d6+1"
    )
  end

  it "is valid with a name, feature_type, and description" do
    feature = adversary.features.build(name: "Bite", feature_type: "Action", description: "Chomp.")
    expect(feature).to be_valid
  end

  it "requires feature_type to be Passive, Action, or Reaction" do
    feature = adversary.features.build(name: "Bite", feature_type: "Magic", description: "Chomp.")
    expect(feature).not_to be_valid
    expect(Feature::TYPES).to eq(%w[Passive Action Reaction])
  end

  it "requires an adversary" do
    expect(Feature.new(name: "Bite", feature_type: "Action", description: "Chomp.")).not_to be_valid
  end

  it "is destroyed when its adversary is destroyed" do
    feature = adversary.features.create!(name: "Bite", feature_type: "Action", description: "Chomp.")
    adversary.destroy
    expect(Feature.exists?(feature.id)).to eq(false)
  end
end

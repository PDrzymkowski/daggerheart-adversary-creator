require "rails_helper"

RSpec.describe "Adversaries", type: :request do
  def valid_params(overrides = {})
    {
      adversary: {
        name: "Test Adversary", tier: 1, adversary_type: "Bruiser", difficulty: 10,
        hp: 5, stress: 3, atk: 1, attack_name: "Claws", attack_range: "Melee",
        attack_damage: "1d6+1",
        features_attributes: { "0" => { name: "Bite", feature_type: "Action", description: "Chomp." } }
      }.merge(overrides)
    }
  end

  it "GET /adversaries succeeds" do
    get adversaries_path
    expect(response).to have_http_status(:ok)
  end

  it "GET /adversaries/new succeeds" do
    get new_adversary_path
    expect(response).to have_http_status(:ok)
  end

  it "creates an adversary with a nested feature" do
    expect {
      post adversaries_path, params: valid_params
    }.to change(Adversary, :count).by(1).and change(Feature, :count).by(1)
    expect(response).to redirect_to(adversaries_path)
  end

  it "re-renders new with errors on invalid params" do
    post adversaries_path, params: valid_params(name: "")
    expect(response).to have_http_status(:unprocessable_content)
  end

  it "GET /adversaries/:id/edit succeeds" do
    adversary = Adversary.create!(valid_params[:adversary].except(:features_attributes))
    get edit_adversary_path(adversary)
    expect(response).to have_http_status(:ok)
  end

  it "updates a non-template adversary in place" do
    adversary = Adversary.create!(valid_params[:adversary].except(:features_attributes))
    patch adversary_path(adversary), params: { adversary: { name: "Renamed" } }
    expect(adversary.reload.name).to eq("Renamed")
  end

  it "forks a new record instead of mutating a template on update" do
    template = Adversary.create!(valid_params[:adversary].except(:features_attributes).merge(template: true))
    expect {
      patch adversary_path(template), params: { adversary: { name: "Forked" } }
    }.to change(Adversary, :count).by(1)
    expect(template.reload.name).to eq("Test Adversary")
    expect(Adversary.find_by(name: "Forked").template).to eq(false)
  end

  it "forks a template into a new adversary when the submitted form includes the template's real feature id" do
    template = Adversary.create!(valid_params[:adversary].merge(template: true))
    original_feature = template.features.sole

    expect {
      patch adversary_path(template), params: {
        adversary: {
          name: "Forked With Features",
          features_attributes: {
            "0" => {
              id: original_feature.id,
              name: original_feature.name,
              feature_type: original_feature.feature_type,
              description: original_feature.description,
              position: 0
            }
          }
        }
      }
    }.to change(Adversary, :count).by(1)

    expect(response).to redirect_to(adversaries_path)

    forked = Adversary.find_by(name: "Forked With Features")
    expect(forked).to be_present
    expect(forked.template).to eq(false)
    expect(forked.features.count).to eq(1)
    expect(forked.features.sole.name).to eq("Bite")
    expect(forked.features.sole.id).not_to eq(original_feature.id)

    template.reload
    expect(template.name).to eq("Test Adversary")
    expect(template.features.count).to eq(1)
    original_feature.reload
    expect(original_feature.name).to eq("Bite")
    expect(original_feature.adversary_id).to eq(template.id)
  end

  it "forks a template, excluding a feature the user marked for removal via _destroy" do
    template = Adversary.create!(valid_params[:adversary].except(:features_attributes).merge(template: true))
    kept_feature = template.features.create!(name: "Bite", feature_type: "Action", description: "Chomp.", position: 0)
    removed_feature = template.features.create!(name: "Claw", feature_type: "Action", description: "Scratch.", position: 1)

    expect {
      patch adversary_path(template), params: {
        adversary: {
          name: "Forked Minus A Feature",
          features_attributes: {
            "0" => {
              id: kept_feature.id,
              name: kept_feature.name,
              feature_type: kept_feature.feature_type,
              description: kept_feature.description,
              position: 0
            },
            "1" => {
              id: removed_feature.id,
              name: removed_feature.name,
              feature_type: removed_feature.feature_type,
              description: removed_feature.description,
              position: 1,
              _destroy: "1"
            }
          }
        }
      }
    }.to change(Adversary, :count).by(1)

    expect(response).to redirect_to(adversaries_path)

    forked = Adversary.find_by(name: "Forked Minus A Feature")
    expect(forked).to be_present
    expect(forked.features.count).to eq(1)
    expect(forked.features.sole.name).to eq("Bite")

    template.reload
    expect(template.features.count).to eq(2)
    expect(template.features.pluck(:name)).to contain_exactly("Bite", "Claw")
  end

  it "destroys an adversary" do
    adversary = Adversary.create!(valid_params[:adversary].except(:features_attributes))
    expect {
      delete adversary_path(adversary)
    }.to change(Adversary, :count).by(-1)
  end
end

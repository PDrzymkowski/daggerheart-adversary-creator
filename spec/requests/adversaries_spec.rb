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

  it "destroys an adversary" do
    adversary = Adversary.create!(valid_params[:adversary].except(:features_attributes))
    expect {
      delete adversary_path(adversary)
    }.to change(Adversary, :count).by(-1)
  end
end

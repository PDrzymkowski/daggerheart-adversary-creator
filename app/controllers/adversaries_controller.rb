class AdversariesController < ApplicationController
  before_action :set_adversary, only: %i[edit update destroy]

  def index
    @templates = Adversary.where(template: true).order(:tier, :name)
    @adversaries = Adversary.where(template: false).order(created_at: :desc)
  end

  def new
    @adversary = if params[:template_id]
      Adversary.find(params[:template_id]).dup_with_features
    else
      Adversary.new(
        tier: 1, adversary_type: Adversary::TYPES.first, attack_range: Adversary::RANGES.first,
        difficulty: 10, hp: 5, stress: 3, atk: 0
      )
    end
  end

  def edit
  end

  def create
    @adversary = Adversary.new(adversary_params)
    @adversary.template = false
    if @adversary.save
      redirect_to adversaries_path, notice: "Adversary saved."
    else
      render :new, status: :unprocessable_content
    end
  end

  def update
    if @adversary.template?
      forked = @adversary.dup_with_features
      forked.assign_attributes(adversary_params)
      forked.template = false
      if forked.save
        redirect_to adversaries_path, notice: "Saved as a new adversary."
      else
        @adversary = forked
        render :edit, status: :unprocessable_content
      end
    elsif @adversary.update(adversary_params)
      redirect_to adversaries_path, notice: "Adversary updated."
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    @adversary.destroy
    redirect_to adversaries_path, notice: "Adversary deleted."
  end

  private

  def set_adversary
    @adversary = Adversary.find(params[:id])
  end

  def adversary_params
    params.require(:adversary).permit(
      :name, :tier, :adversary_type, :type_suffix, :description, :motives_tactics,
      :difficulty, :threshold_major, :threshold_severe, :hp, :stress, :atk,
      :attack_name, :attack_range, :attack_damage, :attack_type, :experience,
      features_attributes: [ :id, :name, :feature_type, :description, :position, :_destroy ]
    )
  end
end

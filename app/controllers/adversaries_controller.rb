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
      forked.assign_attributes(fork_safe_params)
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

  # Same permitted params as #adversary_params, but with each features_attributes
  # entry's :id and :_destroy stripped. Used only when forking a template on
  # update: the form submits the TEMPLATE's real, persisted feature ids, but
  # dup_with_features gives the fork brand-new, unsaved (id-less) features, so
  # those ids don't belong to any record on the fork. Treating every submitted
  # feature as a new record on the fork avoids Rails' nested attributes trying
  # (and failing) to look up the original's feature ids among the fork's features.
  def fork_safe_params
    permitted = adversary_params
    features = permitted[:features_attributes]
    return permitted unless features

    permitted[:features_attributes] = features.to_h.transform_values do |feature_attrs|
      feature_attrs.except(:id, "id", :_destroy, "_destroy")
    end
    permitted
  end
end

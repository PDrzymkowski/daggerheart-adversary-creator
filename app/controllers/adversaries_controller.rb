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
      forked = @adversary.dup
      forked.template = false
      forked.assign_attributes(fork_safe_params)
      forked.features = fork_features
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

  # Same permitted params as #adversary_params, minus features_attributes.
  # Used only when forking a template on update: the fork's features are built
  # separately (see #fork_features) from the SAME submitted params, so they
  # must not also be assigned here — assigning them via both paths is exactly
  # what caused every feature to be duplicated on the fork.
  def fork_safe_params
    adversary_params.except(:features_attributes)
  end

  # Builds the fork's features straight from the submitted features_attributes,
  # as the sole source of truth for what the fork should have. Used only when
  # forking a template on update.
  #
  # The submitted ids belong to the TEMPLATE's persisted features, not to the
  # fork (which starts with no features of its own via plain #dup), so keeping
  # them would make Rails' nested attributes try, and fail, to reconcile them
  # against the fork. Every surviving entry is therefore built as a brand-new,
  # unsaved Feature.
  #
  # Entries marked _destroy (features the user removed in the builder before
  # submitting) are dropped entirely rather than assigned: there is nothing to
  # destroy on an unsaved fork, and simply omitting them keeps the removal
  # intent instead of silently discarding it.
  def fork_features
    features = adversary_params[:features_attributes] || {}
    features.to_h.values.filter_map do |feature_attrs|
      attrs = feature_attrs.to_h
      next if ActiveModel::Type::Boolean.new.cast(attrs["_destroy"] || attrs[:_destroy])

      Feature.new(attrs.except("id", :id, "_destroy", :_destroy))
    end
  end
end

function blankFeature() {
  return { id: null, name: "", feature_type: "Passive", description: "", _destroy: false }
}

window.adversaryBuilder = function () {
  return {
    id: null,
    name: "",
    tier: 1,
    adversary_type: "Bruiser",
    type_suffix: "",
    description: "",
    motives_tactics: "",
    difficulty: 10,
    threshold_major: null,
    threshold_severe: null,
    hp: 5,
    stress: 3,
    atk: 0,
    attack_name: "",
    attack_range: "Melee",
    attack_damage: "",
    attack_type: "",
    experience: "",
    features: [],
    templates: [],
    selectedTemplateId: "",

    init() {
      this.templates = JSON.parse(this.$el.dataset.templates || "[]")
      const initial = JSON.parse(this.$el.dataset.adversary || "null")
      if (initial) Object.assign(this, initial)
      if (this.features.length === 0) this.features.push(blankFeature())
    },

    typeLine() {
      return `Tier ${this.tier} ${this.adversary_type}${this.type_suffix ? " " + this.type_suffix : ""}`
    },
    thresholdLine() {
      return this.threshold_major && this.threshold_severe ? `${this.threshold_major}/${this.threshold_severe}` : "None"
    },
    atkLine() {
      return this.atk >= 0 ? `+${this.atk}` : `${this.atk}`
    },
    damageLine() {
      return [this.attack_damage, this.attack_type].filter(Boolean).join(" ")
    },
    addFeature() {
      this.features.push(blankFeature())
    },
    removeFeature(index) {
      const feature = this.features[index]
      if (feature.id) {
        feature._destroy = true
      } else {
        this.features.splice(index, 1)
      }
    },
  }
}

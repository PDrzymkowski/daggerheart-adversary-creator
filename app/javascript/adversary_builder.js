import * as htmlToImage from "html-to-image"

function blankFeature() {
  return { id: null, name: "", feature_type: "Passive", description: "", _destroy: false }
}

function blankExperience() {
  return { name: "", value: null }
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
    features: [],
    experiences: [],
    templates: [],
    selectedTemplateId: "",
    i18n: {},

    init() {
      this.templates = JSON.parse(this.$el.dataset.templates || "[]")
      this.i18n = JSON.parse(this.$el.dataset.i18n || "{}")
      const initial = JSON.parse(this.$el.dataset.adversary || "null")
      if (initial) Object.assign(this, initial)
      if (this.features.length === 0) this.features.push(blankFeature())
      if (!this.experiences || this.experiences.length === 0) this.experiences = [blankExperience()]
    },

    typeLine() {
      const typeLabel = this.i18n.adversaryTypes?.[this.adversary_type] ?? this.adversary_type
      return `${this.i18n.tier ?? "Tier"} ${this.tier} ${typeLabel}${this.type_suffix ? " " + this.type_suffix : ""}`
    },
    templateLabel(template) {
      const typeLabel = this.i18n.adversaryTypes?.[template.adversary_type] ?? template.adversary_type
      return `${this.i18n.tier ?? "Tier"} ${template.tier} ${typeLabel}: ${template.name}`
    },
    rangeLabel() {
      return this.i18n.ranges?.[this.attack_range] ?? this.attack_range
    },
    featureTypeLabel(featureType) {
      return this.i18n.featureTypes?.[featureType] ?? featureType
    },
    thresholdLine() {
      return this.threshold_major && this.threshold_severe
        ? `${this.threshold_major}/${this.threshold_severe}`
        : this.i18n.none ?? "None"
    },
    atkLine() {
      return this.atk >= 0 ? `+${this.atk}` : `${this.atk}`
    },
    damageLine() {
      const damageTypeLabel = this.i18n.damageTypes?.[this.attack_type] ?? this.attack_type
      return [this.attack_damage, damageTypeLabel].filter(Boolean).join(" ")
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
    addExperience() {
      this.experiences.push(blankExperience())
    },
    removeExperience(index) {
      this.experiences.splice(index, 1)
    },
    experienceValueLine(value) {
      if (value === null || value === "" || value === undefined) return ""
      return `+${value}`
    },
    experienceLine() {
      return this.experiences
        .filter((exp) => exp.name)
        .map((exp) => [exp.name, this.experienceValueLine(exp.value)].filter(Boolean).join(" "))
        .join(", ")
    },
    loadTemplate(index) {
      if (index === "") return
      const template = this.templates[index]
      if (!template) return
      Object.assign(this, template)
      this.id = null
      if (this.features.length === 0) this.features.push(blankFeature())
      if (!this.experiences || this.experiences.length === 0) this.experiences = [blankExperience()]
    },
    downloadPng() {
      htmlToImage.toPng(this.$refs.card).then((dataUrl) => {
        const link = document.createElement("a")
        link.download = (this.name || "adversary").toLowerCase().replace(/\s+/g, "-") + ".png"
        link.href = dataUrl
        link.click()
      })
    },
  }
}

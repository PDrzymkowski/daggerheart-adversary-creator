Adversary.where(template: true).destroy_all

Adversary.create!(
  name: "Gate Guardian", tier: 1, adversary_type: "Leader", template: true,
  description: "A decaying umbra-touched humanoid with a cruel scythe draped in shadows",
  motives_tactics: "Protect, call reinforcements, cull the living",
  difficulty: 14, threshold_major: 9, threshold_severe: 17, hp: 7, stress: 4, atk: 2,
  attack_name: "Scytheblade", attack_range: "Melee", attack_damage: "1d12+2",
  experience: "Hold the Line +2",
  features_attributes: [
    { name: "Umbra-touched", feature_type: "Passive", description: "The Guardian gets a critical hit on a 19 or 20.", position: 0 },
    { name: "Guardian's Protection", feature_type: "Passive", description: "The Guardian is resistant to physical damage.", position: 1 },
    { name: "Sweeping Scythe", feature_type: "Action", description: "Spend a Fear to make an attack against all targets in Very Close range. On a success, the target takes 1d10+4 physical damage.", position: 2 },
    { name: "Hallowed Cry", feature_type: "Reaction", description: "When the Guardian takes physical damage, Spend a Fear to summon 2 Skeleton Dredges, who appear at Close range and immediately take the spotlight.", position: 3 }
  ]
)

Adversary.create!(
  name: "Giant Brawler", tier: 2, adversary_type: "Bruiser", template: true,
  description: "An especially muscular giant wielding a warhammer larger than a human.",
  motives_tactics: "Make a living, overwhelm, slam, topple",
  difficulty: 15, threshold_major: 12, threshold_severe: 28, hp: 7, stress: 4, atk: 2,
  attack_name: "Warhammer", attack_range: "Very Close", attack_damage: "2d12+3", attack_type: "phy",
  experience: "Intrusion +2",
  features_attributes: [
    { name: "Battering Ram", feature_type: "Action", description: "Mark a Stress to have the Brawler charge at an inanimate object within Close range they could feasibly smash (such as a wall, cart, or market stand) and destroy it. All targets within Very Close range of the object must succeed on an Agility Reaction Roll or take 2d4+3 physical damage from the shrapnel.", position: 0 },
    { name: "Bloody Reprisal", feature_type: "Reaction", description: "When the Brawler marks 2 or more HP from an attack within Very Close range, you can make a standard attack against the attacker. On a success, the Brawler deals 2d6+15 physical damage instead of their standard damage.", position: 1 },
    { name: "Momentum", feature_type: "Reaction", description: "When the Brawler makes a successful attack against a PC, you gain a Fear.", position: 2 }
  ]
)

Adversary.create!(
  name: "Archer Squadron", tier: 2, adversary_type: "Horde", type_suffix: "(2/HP)", template: true,
  description: "A group of trained archers bearing massive bows.",
  motives_tactics: "Stick together, survive, volley fire",
  difficulty: 13, threshold_major: 8, threshold_severe: 16, hp: 4, stress: 3, atk: 0,
  attack_name: "Longbow", attack_range: "Far", attack_damage: "2d6+3", attack_type: "phy",
  features_attributes: [
    { name: "Horde (1d6+3)", feature_type: "Passive", description: "When damage reaches half HP or more, standard attacks deal 1d6+3 physical damage instead.", position: 0 },
    { name: "Focused Volley", feature_type: "Action", description: "Expend a Fear token to target a distant point. Make an advantaged attack against all creatures within Close range of that location. Successful targets take 1d10+4 physical damage.", position: 1 },
    { name: "Suppressing Fire", feature_type: "Action", description: "Mark a Stress to target a distant point. Until the next Fear roll, creatures moving within Close range of that location must make an Agility Reaction Roll, taking 2d6+3 physical damage on failure or half on success.", position: 2 }
  ]
)

Adversary.create!(
  name: "Giant Rat", tier: 1, adversary_type: "Minion", template: true,
  description: "A cat-sized rodent skilled at scavenging and survival.",
  motives_tactics: "Burrow, hunger, scavenge, wear down",
  difficulty: 10, hp: 1, stress: 1, atk: -4,
  attack_name: "Claws", attack_range: "Melee", attack_damage: "1", attack_type: "phy",
  experience: "Keen Senses +3",
  features_attributes: [
    { name: "Minion (3)", feature_type: "Passive", description: "The Rat is defeated when they take any damage. For every 3 damage a PC deals to the Rat, defeat an additional Minion within range the attack would succeed against.", position: 0 },
    { name: "Group Attack", feature_type: "Action", description: "Spend a Fear to choose a target and spotlight all Giant Rats within Close range of them. Those Minions move into Melee range of the target and make one shared attack roll. On a success, they deal 1 physical damage each. Combine this damage.", position: 1 }
  ]
)

Adversary.create!(
  name: "Assassin Poisoner", tier: 2, adversary_type: "Skulk", template: true,
  description: "A cunning scoundrel skilled in both poisons and ambushing.",
  motives_tactics: "Anticipate, get paid, kill, taint food and water",
  difficulty: 14, threshold_major: 8, threshold_severe: 16, hp: 4, stress: 4, atk: 3,
  attack_name: "Poisoned Throwing Dagger", attack_range: "Close", attack_damage: "2d8+1", attack_type: "phy",
  experience: "Intrusion +2",
  features_attributes: [
    { name: "Grindeloth Venom", feature_type: "Passive", description: "Targets who mark HP from the Assassin's attacks are Vulnerable until they clear a HP.", position: 0 },
    { name: "Out of Nowhere", feature_type: "Passive", description: "The Assassin has advantage on attacks if they are Hidden.", position: 1 },
    { name: "Fumigation", feature_type: "Action", description: "Drop a smoke bomb that fills the air within Close range with smoke, Dizzying all targets in this area. Dizzied targets have disadvantage on their next action roll, then clear the condition.", position: 2 }
  ]
)

puts "Seeded #{Adversary.where(template: true).count} template adversaries."

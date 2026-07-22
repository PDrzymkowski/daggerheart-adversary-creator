class AddExperiencesToAdversaries < ActiveRecord::Migration[8.1]
  class Adversary < ActiveRecord::Base
  end

  def up
    add_column :adversaries, :experiences, :json, default: []

    Adversary.reset_column_information
    Adversary.find_each do |adversary|
      text = adversary.experience.to_s.strip
      next if text.empty?

      if (match = text.match(/\A(.+?)\s*([+-]\d+)\z/))
        entry = { "name" => match[1], "value" => match[2].to_i }
      else
        entry = { "name" => text, "value" => nil }
      end

      adversary.update_column(:experiences, [entry])
    end

    remove_column :adversaries, :experience
  end

  def down
    add_column :adversaries, :experience, :string

    Adversary.reset_column_information
    Adversary.find_each do |adversary|
      first = adversary.experiences&.first
      next unless first

      text = first["value"] ? "#{first["name"]} #{first["value"] >= 0 ? "+" : ""}#{first["value"]}" : first["name"]
      adversary.update_column(:experience, text)
    end

    remove_column :adversaries, :experiences
  end
end

# Daggerheart Adversary Creator

A minimal Rails app for composing [Daggerheart](https://daggerheart.org/reference/adversaries)
adversary stat blocks: fill in a form, watch the card preview update live, download it as a PNG.
Ships with 5 real adversaries (Gate Guardian, Giant Brawler, Archer Squadron, Giant Rat,
Assassin Poisoner) as prefillable templates.

## Setup

Requires Ruby (see `.ruby-version`) and SQLite. If you don't have a Ruby version manager:

```bash
brew install rbenv ruby-build
echo 'eval "$(rbenv init - zsh)"' >> ~/.zshrc && eval "$(rbenv init - zsh)"
rbenv install "$(cat .ruby-version)"
```

Then:

```bash
bundle install
bin/rails db:prepare   # creates the db, loads the schema, seeds — safe to re-run
```

## Running

```bash
bin/dev
```

Visit `http://localhost:3000`.

## Tests

```bash
bundle exec rspec
```

## Architecture

One `Adversary` model (`has_many :features`), one controller (`AdversariesController`),
one builder page (form + live card preview on the same screen). Alpine.js holds all form
state client-side and drives both the form inputs and the card preview from one shared
object, so the preview updates on every keystroke with no server round-trip. "Download PNG"
snapshots the card's DOM node client-side via `html-to-image`. No accounts, no JS build step
— Tailwind and Alpine both ship via importmap.

Seeded templates are read-only in the UI: picking one prefills the builder, but saving
always creates a new record (editing a template forks a copy rather than overwriting it).

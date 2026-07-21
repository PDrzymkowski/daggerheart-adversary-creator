# Pin npm packages by running ./bin/importmap

pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/javascript/controllers", under: "controllers"
pin "alpinejs" # @3.15.12
pin "html-to-image" # @1.11.11 (UMD build, re-exported as ESM; see vendor/javascript/html-to-image.js)
pin "adversary_builder"

import "@hotwired/turbo-rails"
import "controllers"
import jQuery from "jquery"
import Rails from "@rails/ujs"

window.jQuery = jQuery
window.$ = jQuery

Rails.start()

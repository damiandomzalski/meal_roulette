// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import { initializeDataTable } from "./modules/dataTableModule"

document.addEventListener("turbo:load", function() {
  initializeDataTable('.shopping-list-table');
});
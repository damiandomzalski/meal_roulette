// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import { initializeDataTable } from "./modules/dataTableModule"

$(document).ready(() => {
  initializeDataTable('.shopping-list-table');
});
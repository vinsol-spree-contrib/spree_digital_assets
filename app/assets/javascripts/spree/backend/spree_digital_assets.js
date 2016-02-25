// Placeholder manifest file.
// the installer will append this file to the app vendored assets here: vendor/assets/javascripts/spree/backend/all.js'
//= require jquery.remotipart

$( document ).ready(function() {
  $('#folder_list').on('click', '.toggle_list_menu', function() {
    $(this).parent().find('.tree-menu').slideToggle();
  });
});

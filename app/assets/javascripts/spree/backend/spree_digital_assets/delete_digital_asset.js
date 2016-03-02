$(document).ready(function() {
  $('#main-part').on('ajax:success', '.delete_digital_asset_button', function() {
    $(this).closest('.asset-area').remove();
  });
});

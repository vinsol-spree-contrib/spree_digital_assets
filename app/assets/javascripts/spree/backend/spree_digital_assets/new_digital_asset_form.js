function reset_new_digital_asset_form(){
  var $new_digital_asset_form = $('#new_digital_asset_form');
  $new_digital_asset_form[0].reset();
  $new_digital_asset_form.find('.formError').remove();
}

$(document).ready(function() {
  $('body').on('show.bs.modal', '#upload_asset_modal', function(){
    reset_new_digital_asset_form();
  });
});

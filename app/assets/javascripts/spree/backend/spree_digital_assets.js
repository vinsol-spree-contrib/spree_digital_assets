// Placeholder manifest file.
// the installer will append this file to the app vendored assets here: vendor/assets/javascripts/spree/backend/all.js'
//= require jquery.remotipart

$( document ).ready(function() {
  $('.tree-menu-container').on('click', '.toggle_list_menu', function() {
    $(this).parent().find('.tree-menu').slideToggle();
  });

  $('#associate_asset_modal').on('click', '.attachment', function() {
    $('#digital_asset_id_field').val($(this).attr('data-id'));
    $('#digital_asset_file_name').val($(this).attr('data-name'));
    $(this).parent().siblings().removeClass('active');
    $(this).parent().addClass('active');
  });

  $(window).scroll(function() {
     if($(window).scrollTop() + $(window).height() == $(document).height()) {

     }
  });

});

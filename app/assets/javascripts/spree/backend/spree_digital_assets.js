// Placeholder manifest file.
// the installer will append this file to the app vendored assets here: vendor/assets/javascripts/spree/backend/all.js'
//= require jquery.remotipart

$( document ).ready(function() {

  $('.tree-menu-container').on('click', '.toggle_list_menu', function() {
    $(this).parent().find('.tree-menu').slideToggle();
  });

  $('#associate_asset_modal').on('click', '.asset-area', function() {
    $('#digital_asset_id_field').val($(this).find('.attachment').attr('data-id'));
    $('#digital_asset_file_name').val($(this).find('.attachment').attr('data-name'));
    $(this).siblings().removeClass('active');
    $(this).addClass('active');
  });


  $('#associate_asset_modal').on('dblclick', '.asset-area', function() {
    $('#associate_asset_modal').modal('hide');
  });
  var ready = true;

  var load_more_objects = function() {
    url = $('#folder_assets').attr('data-next-url');

    if(ready && ($(window).scrollTop() >= $('#folder_assets').offset().top + $('#folder_assets').outerHeight() - window.innerHeight) && $('#folder_assets').length > 0 && url) {
      ready = false;
      $.ajax({
        url: url,
        method: 'GET',
        dataType: 'script',
        complete: function(){
          ready = true;
        }
      });
    }
  }

  $('#associate_asset_modal').on('scroll', function() {
    load_more_objects();
  });

  $('#main-part').on('ajax:success', '.delete_digital_asset_button', function() {
    $(this).closest('.asset-area').remove();
  });


  $(window).scroll(function() {
    load_more_objects();
  });

  $("body").on('click', '#main-sidebar #folder_list a[data-remote=true]', function(){
    history.pushState('', '', $(this).attr('href'));
  });

  $('#main-sidebar #folder_list a[data-remote=true]').on('ajax:beforeSend', function(){
    $("#progress").stop(true, true).fadeIn();
  });

  $('#main-sidebar #folder_list a[data-remote=true]').on('ajax:complete', function(){
    $("#progress").fadeOut();
  });

  $('#upload_asset_modal_body #folder_list a[data-remote=true]').on('ajax:beforeSend', function(){
    show_loader('#folder_assets');
  });

  $('#upload_asset_modal_body #folder_list a[data-remote=true]').on('ajax:complete', function(){
    hide_loader();
  });

  $("#upload_asset_modal").on("shown.bs.modal", function(){
    $(this).find('#new_digital_asset_form')[0].reset();
    $(this).find('.formError').remove();
  })

});

function show_loader(selector){
  var $loader = $('<div>').addClass('loader').html('<div class="spinner folder-assets-loader"></div><div class="section-overlay"></div>');
  $(selector).append($loader);
}

function hide_loader(){
  $('.loader').remove();
}
